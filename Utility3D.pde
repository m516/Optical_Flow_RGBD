class Vertex {
  PVector location;
  BVHNode volumeContainer;
  ArrayList<Triangle> triangles;
}

class Edge {
  Vertex[] vertices = new Vertex[2];
  Triangle[] adjacentTriangles = new Triangle[2];
}

class Triangle {
  Vertex[] vertices = new Vertex[3];
  Triangle[] adjacentTriangles = new Triangle[3];
}
