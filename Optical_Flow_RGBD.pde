import peasy.*; //<>// //<>// //<>// //<>//

RGBDImage img;
PeasyCam cam;

BVH bvh;
boolean autoRotate = true;

void setup(){
  //Set up renderer
  size(1280,720, P3D); //<>//
  smooth(8);
  
  
  cam = new PeasyCam(this, 1000);
    
    
  //Create the BVH and add points to it
  bvh = new BVH();
  
  img = loadRGBDImage(2);
}
void draw(){
  if(autoRotate){
    cam.rotateY(.01);
  }
  
  background(32);
  lights();
  bvh.draw();
  bvh.drawVertices();
  
}

void mousePressed(){
  autoRotate = false;
}

void keyPressed(){
  if(key=='a'){
    autoRotate = true;
    return;
  }
  bvh.clear();
  
  Vertex victor = new Vertex();
  victor.location = PVector.random3D();
  victor.location.mult(100);
  bvh.add(victor);
  
  Vertex vincent = new Vertex();
  vincent.location = PVector.random3D();
  vincent.location.mult(100);
  bvh.add(vincent);
  
  Vertex velma = new Vertex();
  velma.location = PVector.random3D();
  velma.location.mult(100);
  bvh.add(velma);
  
  Vertex violet = new Vertex(PVector.random3D());
  violet.location.mult(100);
  bvh.add(violet);
  
  Triangle tri = new Triangle(victor, vincent, velma);
  tri.commitToVertices();
  
  tri.add(violet);
}
