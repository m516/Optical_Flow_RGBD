import peasy.*; //<>//

RGBDImage img;
PeasyCam cam;

BVH bvh;
Triangle tri;
boolean autoRotate = true;



void setup(){
  //Set up renderer
  size(1280,720, P3D); //<>//
  frameRate(40);
  hint(DISABLE_OPENGL_ERRORS);
  hint(DISABLE_TEXTURE_MIPMAPS);
  
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
  
  if(tri!=null){
    stroke(255,255,0);
    strokeWeight(6);
    beginShape(TRIANGLES);
    tri.draw();
    endShape();
  }
  
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
  victor.location.mult(200);
  bvh.add(victor);
  
  Vertex vincent = new Vertex();
  vincent.location = PVector.random3D();
  vincent.location.mult(200);
  bvh.add(vincent);
  
  Vertex velma = new Vertex();
  velma.location = PVector.random3D();
  velma.location.mult(200);
  bvh.add(velma);
  
  Vertex violet = new Vertex(new PVector(0,0,0));
  bvh.add(violet);
  
  tri = new Triangle(victor, vincent, velma);
  tri.commitToVertices();
  
  tri.add(violet);
}
