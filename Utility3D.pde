import java.util.LinkedList;

//TODO create BVH class that manages the bounding volume heirachy and
//dynamically creates leaves and branches as necessary.

//The nodes of a Bounding Volume Heirarchy
abstract class BVHNode {  
  //The BVHNode that contains this BVHNode
  protected BVHBranch parent;
  //The lower boundary for this node
  protected PVector lowerBound;
  protected PVector upperBound;
  
  //Adds a vertex to the BVH leaf that contains the position at V
  public abstract void add(Vertex v);

  public PVector getLowerBound() {
    return lowerBound;
  }
  public PVector getUpperBound() {
    return upperBound;
  }
  public BVHBranch getParentNode() {
    return parent;
  }
  public PVector getDimension() {
    return PVector.sub(upperBound, lowerBound);
  }

  public boolean positionInBounds(PVector position) {
    if (position.x < lowerBound.x) return false;
    if (position.x > upperBound.x) return false;
    if (position.y < lowerBound.y) return false;
    if (position.y > upperBound.y) return false;
    if (position.z < lowerBound.z) return false;
    if (position.z > upperBound.z) return false;
    return true;
  }

  public abstract BVHLeaf getLeafFor(PVector position);
}

class BVHBranch extends BVHNode {
  public static final int DEFAULT_NUM_SUBDIVISIONS = 2;
  BVHNode[][][] children;
  
  public BVHBranch(BVHBranch parent, PVector lowerBound, PVector upperBound){
    this.parent = parent;
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
    children = new BVHNode[DEFAULT_NUM_SUBDIVISIONS][DEFAULT_NUM_SUBDIVISIONS][DEFAULT_NUM_SUBDIVISIONS];
  }
  
  public BVHBranch(BVHBranch parent, PVector lowerBound, PVector upperBound, int numSubdivisions){
    this.parent = parent;
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
    children = new BVHNode[numSubdivisions][numSubdivisions][numSubdivisions];
  }
  
  public void add(Vertex v){
    //TODO Stub
    println("Called a stub in " + getClass());
  }
  
  public BVHLeaf getLeafFor(PVector position) {
    //Test if this branch contains the position
    if (!positionInBounds(position)) {
      if (parent == null) return null;
      return parent.getLeafFor(position);
    }

    //This branch has this position. Find it.
    PVector relativePosition = position.copy().sub(lowerBound);
    PVector dimension = getDimension();
    relativePosition.x /= dimension.x;
    relativePosition.y /= dimension.y;
    relativePosition.z /= dimension.z;

    int sectorX = int(relativePosition.x*float(NUM_SUBDIVISIONS));
    int sectorY = int(relativePosition.y*float(NUM_SUBDIVISIONS));
    int sectorZ = int(relativePosition.z*float(NUM_SUBDIVISIONS));

    return children[sectorX][sectorY][sectorZ].getLeafFor(position);
  }
}

class BVHLeaf extends BVHNode {
  //The list of vertices that are exclusively in this BVH
  //We'll only need to append, iterate through, and pop from this list.
  //So a LinkedList is convenient for this scenario.
  LinkedList<PVector> verts;
  
  public void add(Vertex v){
    //TODO Stub
    println("Called a stub in " + getClass());
  }

  public BVHLeaf getLeafFor(PVector position) {
    //Test if this branch contains the position
    if (!positionInBounds(position)) {
      if (parent == null) return null;
      return parent.getLeafFor(position);
    }

    return this;
  }
  
  public BVHBranch transformToBranch(){
    BVHBranch barry = new BVHBranch(parent, lowerBound, upperBound, 3);
    //TODO Place all my vertices in Barry.
    return barry;
  }
}


class Vertex {
  PVector location;
  BVHNode volumeContainer;
  ArrayList<Triangle> triangles;
}

class Edge{
  Vertex[] vertices = new Vertex[2];
  Triangle[] adjacentTriangles = new Triangle[2];
}

class Triangle{
  Vertex[] vertices = new Vertex[3];
  Triangle[] adjacentTriangles = new Triangle[3];
}
