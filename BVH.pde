class BVH { //<>//
  BVHBranch root;

  public BVH() {
    PVector lb = new PVector(-128, -128, -128);
    PVector ub = new PVector( 128, 128, 128);
    root = new BVHBranch(null, lb, ub);
  }

  public void add(Vertex v) {
    //Check if v is bounded by the root node
    while (!root.positionInBounds(v)) {
      PVector dim = root.getDimension();
      PVector lb = PVector.sub(root.lowerBound, dim);
      PVector ub = PVector.add(root.upperBound, dim);
      BVHBranch newRoot = new BVHBranch(null, lb, ub, 3);
      root.parent = newRoot;
      newRoot.initializeChildren();
      newRoot.children[1][1][1] = root;
      root = newRoot;
    }
    root.add(v);
    return;
  }
  
  public void draw(){
    root.drawVertices(); //<>//
  }
}


//The nodes of a Bounding Volume Heirarchy
abstract class BVHNode {
  //The BVHNode that contains this BVHNode
  protected BVHBranch parent;
  //The lower boundary for this node
  protected PVector lowerBound;
  protected PVector upperBound;
  protected int numVertices;

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

  public boolean positionInBounds(Vertex position) {
    return positionInBounds(position.location);
  }
  
  public abstract void drawVertices();

  public abstract BVHLeaf getLeafFor(PVector position);
  
  public int vertexCount(){
    return numVertices;
  }
}

class BVHBranch extends BVHNode {
  private int numSubdivisions = 2;
  BVHNode[][][] children;

  public BVHBranch(BVHBranch parent, PVector lowerBound, PVector upperBound) {
    this.parent = parent;
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
    children = new BVHNode[numSubdivisions][numSubdivisions][numSubdivisions];
    initializeChildren();
    print("LB: ");
    print(lowerBound);
    print("\tUB: ");
    println(upperBound);
  }

  public BVHBranch(BVHBranch parent, PVector lowerBound, PVector upperBound, int numSubdivisions) {
    this.parent = parent;
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
    this.numSubdivisions = numSubdivisions;
    children = new BVHNode[numSubdivisions][numSubdivisions][numSubdivisions];
    initializeChildren();
  }

  private void initializeChildren() {
    PVector dim = getDimension();
    for (int i = 0; i < children.length; i++) {
      for (int j = 0; j < children[i].length; j++) {
        for (int k = 0; k < children[i][j].length; k++) {
          PVector lb = new PVector();
          PVector ub = new PVector();
          lb.x = lowerBound.x + float(i) / float(numSubdivisions) * dim.x;
          lb.y = lowerBound.y + float(j) / float(numSubdivisions) * dim.y;
          lb.z = lowerBound.z + float(k) / float(numSubdivisions) * dim.z;
          ub.x = lowerBound.x + float(i+1) / float(numSubdivisions) * dim.x;
          ub.y = lowerBound.y + float(j+1) / float(numSubdivisions) * dim.y;
          ub.z = lowerBound.z + float(k+1) / float(numSubdivisions) * dim.z;
          children[i][j][k] = new BVHLeaf(this,
            lb,
            ub);
        }
      }
    }
  }

  public void add(Vertex v) {
    println("Entering " + toString());

    PVector l = v.location;
    if (!positionInBounds(l)) {
      println("Vertex not bounded by " + toString());
      parent.add(v);
    }

    //The position of the vertex relative to the lower bound of this branch
    PVector r = l.copy().sub(lowerBound);
    //The dimension of this branch
    PVector d = getDimension();

    //Calculate the indices of the node that this vertex should go to.
    //i.e. redirect the vertex to go to its appropriate child BVH node
    int i = int(r.x/d.x*numSubdivisions);
    int j = int(r.y/d.y*numSubdivisions);
    int k = int(r.z/d.z*numSubdivisions);

    children[i][j][k].add(v);

    //If it's a leaf
    if (children[i][j][k] instanceof BVHLeaf) {
      //Split it if necessary
      BVHLeaf bart = (BVHLeaf) children[i][j][k];
      if (bart.readyToSplit()) {
        BVHBranch barry = bart.transformToBranch();
        children[i][j][k] = barry; //Sorry Bart.
      }
    }
    
    numVertices++;
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

    int sectorX = int(relativePosition.x*float(numSubdivisions));
    int sectorY = int(relativePosition.y*float(numSubdivisions));
    int sectorZ = int(relativePosition.z*float(numSubdivisions));
 //<>//
    return children[sectorX][sectorY][sectorZ].getLeafFor(position);
  }
  
  public void drawVertices(){
    for (int i = 0; i < children.length; i++) {
      for (int j = 0; j < children[i].length; j++) {
        for (int k = 0; k < children[i][j].length; k++) {
          children[i][j][k].drawVertices();
        }
      }
    }
  }
}
import java.util.LinkedList;

class BVHLeaf extends BVHNode {
  //The list of vertices that are exclusively in this BVH
  //We'll only need to append, iterate through, and pop from this list.
  //So a LinkedList is convenient for this scenario.
  LinkedList<Vertex> verts;

  //The number of vertices to store until requesting a transformation to a BVH branch
  public static final int MAX_VERTICES = 100;

  public BVHLeaf(BVHBranch parent, PVector lowerBound, PVector upperBound) {
    this.parent = parent;
    this.lowerBound = lowerBound;
    this.upperBound = upperBound;
    verts = new LinkedList<Vertex>();
    print("LB: ");
    print(lowerBound);
    print("\tUB: ");
    println(upperBound);
  }

  public void add(Vertex v) {
    println("Entering " + toString());
    
    //Get the location of this vertex
    PVector l = v.location;
    
    //Check if the vertex is bounded by this leaf
    if (!positionInBounds(l)) {
      println("Vertex not bounded by " + toString());
      parent.add(v); //Not my problem!
      return;
    }
    
    verts.add(v);
    
    numVertices=verts.size();
  }

  public BVHLeaf getLeafFor(PVector position) {
    //Test if this branch contains the position
    if (!positionInBounds(position)) {
      if (parent == null) return null;
      return parent.getLeafFor(position);
    }

    return this;
  }

  public BVHBranch transformToBranch() {
    BVHBranch barry = new BVHBranch(parent, lowerBound, upperBound, 3);
    while (!verts.isEmpty()) {
      Vertex victor = verts.pop();
      barry.add(victor);
    }
    return barry;
  }
 //<>//
  public boolean readyToSplit() {
    return verts.size()>=MAX_VERTICES;
  }
  
  public void drawVertices(){
    beginShape(POINTS);
    for(Vertex v: verts){
      vertex(v.location.x,v.location.y,v.location.z); //<>//
    }
    endShape();
  }
}
