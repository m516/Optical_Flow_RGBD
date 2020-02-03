import peasy.*; //<>// //<>// //<>// //<>//

RGBDImage img;
PeasyCam cam;

BVH bvh;

void setup(){
  //Set up renderer
  size(1280,720, P3D); //<>//
  smooth(8);
  
  
  cam = new PeasyCam(this, 1000);
    
    
  //Create the BVH and add points to it
  bvh = new BVH();
  Vertex victor = new Vertex();
  victor.location = new PVector(5,5,5);
  bvh.add(victor);
  
  Vertex vincent = new Vertex();
  vincent.location = new PVector(129,129,129);
  bvh.add(vincent);
  
  img = loadRGBDImage(2);
}
void draw(){
  background(32);
  stroke(255);
  strokeWeight(8);
  fill(64,128,255);
  lights();
  box(100);
  bvh.draw();
  
}
