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
    
    v1.triangles.add(this);
    v2.triangles.add(this);
    v3.triangles.add(this);
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
    adjacentTriangles[1] = t2;
    adjacentTriangles[2] = t3;
    
    vertices[2] = v;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 0 and 1
  //and another point.
  Triangle extrude01(Vertex v){
    Triangle travis = new Triangle(vertices[1], vertices[0], v);
    adjacentTriangles[0] = travis;
    travis.adjacentTriangles[0] = this;
    return travis;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 1 and 2
  //and another point.
  Triangle extrude12(Vertex v){
    Triangle travis = new Triangle(vertices[2], vertices[1], v);
    adjacentTriangles[1] = travis;
    travis.adjacentTriangles[1] = this;
    return travis;
  }
  
  //Creates a new triangle from this one.
  //It is formed by vertices 2 and 0
  //and another point.
  Triangle extrude20(Vertex v){
    Triangle travis = new Triangle(vertices[0], vertices[2], v);
    adjacentTriangles[2] = travis;
    travis.adjacentTriangles[2] = this;
    return travis;
  }
  
  void draw(){
    vertex(vertices[0].location.x,vertices[0].location.y,vertices[0].location.z);
    vertex(vertices[1].location.x,vertices[1].location.y,vertices[1].location.z);
    vertex(vertices[2].location.x,vertices[2].location.y,vertices[2].location.z);
  }
}
