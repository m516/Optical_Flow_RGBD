RGBDImage img;

void setup(){
  size(1280,720); //<>// //<>//
  img = loadRGBDImage(2);
  
  PVector lb = new PVector(0,0,0);
  PVector ub = new PVector(10,10,10);
  BVHBranch root = new BVHBranch(null, lb, ub);
  Vertex victor = new Vertex();
  victor.location = new PVector(5,5,5); //<>//
  root.add(victor); //<>//
  
  
  Vertex vincent = new Vertex();
  vincent.location = new PVector(9,1,1);
  root.add(vincent);
}
void draw(){
  if(mousePressed){ //<>// //<>//
    image(img.getRGBImage(), 0, 0);    
  }
  else{
    image(img.getDepthImage(), 0, 0);
  }
}
