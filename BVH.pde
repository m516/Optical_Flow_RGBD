class BVH { //<>// //<>// //<>// //<>// //<>//
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

  public void draw() {
    beginShape(TRIANGLES);
    root.draw();
    endShape();
  }

  public void drawVertices() {
    root.drawVertices();
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

  //Returns true if this method modified the destination
  public abstract boolean findClosestVertices(Vertex v, Vertex[] dest);

  public abstract void drawVertices();
  public abstract void draw();

  public abstract BVHLeaf getLeafFor(PVector position);

  public int vertexCount() {
    return numVertices;
  }

  public PVector getClosestPointTo(Vertex v) {
    return getClosestPointTo(v.location);
  }

  public PVector getClosestPointTo(PVector v) {
    PVector r = new PVector();
    r.x = constrain(v.x, lowerBound.x, upperBound.x);
    r.y = constrain(v.y, lowerBound.y, upperBound.y);
    r.z = constrain(v.z, lowerBound.z, upperBound.z);
    return r;
  }
  
  public PVector getFarthestPointFrom(PVector v) {
    PVector r = getClosestPointTo(v);
    r.x = upperBound.x-(r.x-lowerBound.x);
    r.y = upperBound.y-(r.y-lowerBound.y);
    r.z = upperBound.z-(r.z-lowerBound.z);
    return r;
  }
}

//A node that contains nultiple nodes
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

    return children[sectorX][sectorY][sectorZ].getLeafFor(position);
  }

  public boolean findClosestVertices(Vertex v, Vertex[] dest) {
    PVector position = getClosestPointTo(v);
    //This branch has this position. Find it.
    PVector relativePosition = position.copy().sub(lowerBound);
    PVector dimension = getDimension();
    relativePosition.x /= dimension.x;
    relativePosition.y /= dimension.y;
    relativePosition.z /= dimension.z;

    int sectorX = int(relativePosition.x*float(numSubdivisions));
    int sectorY = int(relativePosition.y*float(numSubdivisions));
    int sectorZ = int(relativePosition.z*float(numSubdivisions));

    boolean keepSearching = false;

    //TODO search that sector first
    if (!children[sectorX][sectorY][sectorZ].findClosestVertices(v, dest)) return false;
    //Then search the rest of them
    for (int i = 0; i < children.length; i++) {
      for (int j = 0; j < children[i].length; j++) {
        for (int k = 0; k < children[i][j].length; k++) {
          if (i == sectorX &&
            j == sectorY &&
            k == sectorX) continue;

          if (children[i][j][k].findClosestVertices(v, dest)) {
            if (i == 0 || i == children.length - 1 ||
              j == 0 || j == children[sectorX].length - 1 ||
              k == 0 || k == children[sectorX][sectorY].length - 1) keepSearching = true;
          }
        }
      }
    }



    return keepSearching;
  }

  public void drawVertices() {
    for (int i = 0; i < children.length; i++) {
      for (int j = 0; j < children[i].length; j++) {
        for (int k = 0; k < children[i][j].length; k++) {
          children[i][j][k].drawVertices();
        }
      }
    }
  }
  public void draw() {
    for (int i = 0; i < children.length; i++) {
      for (int j = 0; j < children[i].length; j++) {
        for (int k = 0; k < children[i][j].length; k++) {
          children[i][j][k].draw();
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

  public boolean readyToSplit() {
    return verts.size()>=MAX_VERTICES;
  }

  public boolean findClosestVertices(Vertex v, Vertex[] dest) {
    //Don't do anything if there aren't any vertices
    if (numVertices==0) return true;

    //Check if it is possible for there to be a closer vector
    float minDistance = Float.POSITIVE_INFINITY;
    minDistance = min(dest[0].distanceTo(v), minDistance);

    //Get the closest possible point to the vertex
    float myDistance = v.distanceTo(getClosestPointTo(v));

    //Don't do anything if there can't possibly be a point in this leaf that is closer to this one
    if (myDistance>minDistance) return false;

    //Go through all the points in this leaf and add them to dest in order of distance
    for (Vertex w : verts) {
      float currentDistance = w.distanceTo(v);
      //Iterate through all the points who claim to be the closest to v and test their closeness
      for (int i = 0; i < dest.length; i++) {
        //Add the point if there's nothing to replace it
        if (dest[i] == null) {
          dest[i] = w;
          break;
        }
        float distanceInDest = v.distanceTo(dest[i]);
        //Bump all the points back if w is closer to v than dest[i]
        //Kind of like insertion sort an an array that's being populated with w
        if (currentDistance<distanceInDest) {
          for (int j = dest.length-2; j >= i; j--)
            dest[j+1] = dest[j];
          dest[i] = w;
          break;
        }
        //Otherwise keep searching
      }
    }

    //Keep searching
    return true;
  }

  public void drawVertices() {
    beginShape(POINTS);
    for (Vertex v : verts) {
      vertex(v.location.x, v.location.y, v.location.z);
    }
    endShape();
  }

  public void draw() {
    for (Vertex v : verts) {
      for (Triangle t : v.triangles) {
        if (t.vertices[0]==v) {
          t.draw();
        }
      }
    }
  }
}
