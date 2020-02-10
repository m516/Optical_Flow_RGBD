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
  victor.location = new PVector(0,0,0);
  bvh.add(victor);
  
  Vertex vincent = new Vertex();
  vincent.location = new PVector(100,0,0);
  bvh.add(vincent);
  
  Vertex velma = new Vertex();
  velma.location = new PVector(100,100,0);
  bvh.add(velma);
  
  Vertex violet = new Vertex(0,-100,0);
  bvh.add(violet);
  
  Triangle tri = new Triangle(victor, vincent, velma);
  
  tri.extrude01(violet);
  
  img = loadRGBDImage(2);
}
void draw(){
  background(32);
  stroke(255);
  strokeWeight(8);
  fill(64,128,255);
  lights();
  bvh.draw();
  bvh.drawVertices();
  
}
