class Vertex {
  PVector location;
  BVHNode volumeContainer;
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  
  public Vertex(){
  }
  
  public Vertex(PVector location){
    this.location = location.copy();
  }
  
  public Vertex(float x, float y, float z){
    location = new PVector(x, y, z);
  }
  
  public void makeTriangle(Vertex v2, Vertex v3){
    Triangle t = new Triangle(this, v2, v3);
  }
  
  public float distanceTo(Vertex other){
    return location.dist(other.location);
  }
  
  public float distanceTo(PVector other){
    return location.dist(other);
  }
}

class Edge {
  Vertex[] vertices = new Vertex[2];
  Triangle[] adjacentTriangles = new Triangle[2];
  
  Edge(Vertex v1, Vertex v2){
    vertices[0] = v1;
    vertices[1] = v2;
  }
  
  boolean equals(Edge other){
    if(super.equals(other)) return true;
    return vertices[0].equals(other.vertices[0]) && vertices[1].equals(other.vertices[1]) || vertices[0].equals(other.vertices[1]) && vertices[1].equals(other.vertices[0]);
  }
}

class Triangle {
  Vertex[] vertices = new Vertex[3];
  Triangle[] adjacentTriangles = new Triangle[3];
  
  //Creates a triangle
  public Triangle(Vertex v1, Vertex v2, Vertex v3){
    vertices[0] = v1;
    vertices[1] = v2;
    vertices[2] = v3;
  }
  
  void commitToVertices(){
    vertices[0].triangles.add(this);
    //The other vertices don't need to know that they belong
    //to this triangle. It may actually be detrimental to the
    //performance and memory, and triangles can swap
    //first and second vertices
    //vertices[1].triangles.add(this);
    //vertices[2].triangles.add(this);
  }
  
  //Split this triangle into three subtriangles
  //Vertex v is in the center
  void split(Vertex v){
    Vertex v1 = vertices[0];
    
    Triangle t2 = new Triangle(vertices[1], vertices[2], v);
    Triangle t3 = new Triangle(vertices[2], v, v1);
    
    t2.adjacentTriangles[0] = adjacentTriangles[1];
    t2.adjacentTriangles[1] = t3;
    t2.adjacentTriangles[2] = this;
    t3.adjacentTriangles[0] = adjacentTriangles[2];
    t3.adjacentTriangles[1] = this;
    t3.adjacentTriangles[2] = t2;
    t2.commitToVertices();
    t3.commitToVertices();
    adjacentTriangles[1] = t2;
    adjacentTriangles[2] = t3;
    
    vertices[2] = v;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 0 and 1
  //and another point.
  Triangle extrude01(Vertex v){
    Triangle travis = new Triangle(vertices[1], vertices[0], v);
    travis.commitToVertices();
    adjacentTriangles[0] = travis;
    travis.adjacentTriangles[0] = this;
    return travis;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 1 and 2
  //and another point.
  Triangle extrude12(Vertex v){
    Triangle travis = new Triangle(vertices[2], vertices[1], v);
    travis.commitToVertices();
    adjacentTriangles[1] = travis;
    travis.adjacentTriangles[1] = this;
    return travis;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 2 and 0
  //and another point.
  Triangle extrude20(Vertex v){
    Triangle travis = new Triangle(vertices[0], vertices[2], v);
    travis.commitToVertices();
    adjacentTriangles[2] = travis;
    travis.adjacentTriangles[2] = this;
    return travis;
  }
  
  //Returns the normal for this triangle
  PVector normal(){
    PVector ret = vertices[1].location.copy();
    ret.cross(vertices[1].location);
    return ret;
  }
  
  /*
  //This is dead and deprecated because it doesn't account for correcting long, thin triangles
  void add(Vertex v){
    //Project the vertex v onto the plane containing the triangle
    PVector projectedPos = v.location;
    PVector normal = normal();
    float dist = projectedPos.dot(normal);
    normal.setMag(dist);
    projectedPos.sub(normal);
    
    float a = area();
    float a0 = area(vertices[0], vertices[1], v);
    float a1 = area(vertices[1], vertices[2], v);
    float a2 = area(vertices[2], vertices[0], v);
    
    //Case 1: the point is inside the triangle
    if(a0+a1+a2<a*1.01){
      split(v);
      return;
    }
    
    //Case 2: the point is outside of the triangle
    
  }
  */
  
  void add(Vertex v){
    //Project the vertex v onto the plane containing the triangle
    PVector projectedPos = v.location.copy();
    PVector normal = normal();
    float dist = projectedPos.dot(normal);
    normal.setMag(dist);
    projectedPos.sub(normal);
    
    float a = area();
    float a0 = area(vertices[0], vertices[1], v);
    float a1 = area(vertices[1], vertices[2], v);
    float a2 = area(vertices[2], vertices[0], v);
    float p0 = perimeter(vertices[0], vertices[1], v);
    float p1 = perimeter(vertices[1], vertices[2], v);
    float p2 = perimeter(vertices[2], vertices[0], v);
    float splitAreaToPerimeterRatio = (p0+p1+p2)/3;
    
    
    //Generate all posibilities of couples of triangles.
    Vertex[] vertPool = {vertices[0],vertices[1],vertices[2],v};
    final int[] i1 = {0,0,0,1,1,2};
    final int[] i2 = {1,2,3,2,3,3};
    //Create a pair of triangles with the smallest net 
    //perimeter to area ratio
    Triangle m1,m2 = new Triangle(null,null,null);
    int minI = -1; //Useful for knowing if the shared edge contains this triangle's
                   //master vertex. 0-2 if it does, 3-5 otherwise
    float maxAreaToPerimeterRatio = Float.POSITIVE_INFINITY;
    //For each unique edge that the two triangles can share
    for(int i = 0; i < 6; i++){
      //Ceate a pair of triangles and get their perimeter
      Triangle t1 = new Triangle(vertPool[i1[i]],vertPool[i2[i]],vertPool[i1[5-i]]);
      Triangle t2 = new Triangle(vertPool[i1[i]],vertPool[i2[i]],vertPool[i2[5-i]]);
      float thisRatio = (t1.perimeter()+t2.perimeter())/2;
      //Use this ratio to find the roundest pair of triangles
      if(thisRatio<maxAreaToPerimeterRatio){
        maxAreaToPerimeterRatio = thisRatio;
        m1=t1;
        m2=t2;
        minI = i;
      }
    }
    
    //Case 1: the point is inside the triangle
    if(splitAreaToPerimeterRatio<maxAreaToPerimeterRatio){
      split(v);
      return;
    }
    
    //Case 2: the point is outside the triangle
    //To optimize triangle structure, every triangle has a master vertex at
    //index 0. This should not be changed in a triangle because each vertex stores
    //a list of triangles it owns, and it is time consuming to remove triangles from
    //lists. So restructure this triangle, but don't touch its master vertex.
    
    //If the two triangles share an edge that contains the master vertex, just
    //change this triangle to m1 and continue living life.
    
    //Actually, it turns out that the triangle m1 is the only triangle to contain
    //this triangle's master vertex, so we're fine
    vertices[1] = vertPool[i2[minI]];
    if(minI<3)
      vertices[2] = vertPool[i1[5-minI]];
    else
      vertices[2] = vertPool[i1[minI]];
    
    Triangle thomas = m2;
    thomas.commitToVertices();
  }
  
  public void flipNormal(){
    Vertex temp = vertices[1];
    vertices[1] = vertices[2];
    vertices[2] = temp;
  }
  
  public float area(PVector p1, PVector p2, PVector p3) {
    PVector v1 = PVector.sub(p2, p1), v2 = PVector.sub(p3, p1);
    return v1.cross(v2).mag()/2.0;
  }
  
  public float area(Vertex p1, Vertex p2, Vertex p3) {
    return area(p1.location, p2.location, p3.location);
  }
  
  public float area(){
    return area(vertices[0], vertices[1], vertices[2]);
  }
  
  public float perimeter(PVector p1, PVector p2, PVector p3){
    return p1.dist(p2)+p2.dist(p3)+p3.dist(p1);
  }
  
  public float perimeter(Vertex p1, Vertex p2, Vertex p3) {
    return perimeter(p1.location, p2.location, p3.location);
  }
  
  public float perimeter(){
    return perimeter(vertices[0], vertices[1], vertices[2]);
  }
  
  
  
  void draw(){
    vertex(vertices[0].location.x,vertices[0].location.y,vertices[0].location.z);
    vertex(vertices[1].location.x,vertices[1].location.y,vertices[1].location.z);
    vertex(vertices[2].location.x,vertices[2].location.y,vertices[2].location.z);
  }
}
