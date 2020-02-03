class Vertex {
  PVector location;
  BVHNode volumeContainer;
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  
  public void makeTriangle(Vertex v2, Vertex v3){
    Triangle t;
    t.vertices[0] = this;
    t.vertices[1] = v2;
    t.vertices[2] = v3;
    triangles.add(t);
    v2.triangles.add(t);
    v3.triangles.add(t);
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
    vertices[0] = v;
    
    Triangle t2 = new Triangle(v, vertices[2], v);
    Triangle t3 = new Triangle(v, v1, vertices[1]);
    
    t2.adjacentTriangles[0] = this;
    t2.adjacentTriangles[1] = adjacentTriangles[2];
    t2.adjacentTriangles[2] = t3;
    t3.adjacentTriangles[0] = t2;
    t3.adjacentTriangles[1] = adjacentTriangles[0];
    t3.adjacentTriangles[2] = this;
    adjacentTriangles[0] = t3;
    adjacentTriangles[2] = t3;
  }
  
  //Creates a new triangle from this one and another point.
  Triangle extrude(Vertex v, int edge){
    //TODO
  }
}
