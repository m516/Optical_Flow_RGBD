import pallav.Matrix.*; //<>//
import peasy.*;


//Working with images
RGBDImage img1;
RGBDImage img2;

OpticalFlow1 flow;

void setup() {
  size(1280, 720, P2D);
  
  println("Loading image 1");
  img1 = loadRGBDImage(1);
  println("Loading image 2");
  img2 = loadRGBDImage(2);

  println("Creating OpticalFlow");
  flow = new OpticalFlow1();

  println("Computing");
  flow.compute(img1, img2);
}

void draw() {
  image(img1.rgb, 0, 0);
  tint(255, mouseX*255/width);  // Apply transparency without changing color
  flow.drawUniquenessMap();
  noTint();
}



//Working with meshes
/*

 
 RGBDImage img;
 PeasyCam cam;
 
 BVH bvh;
 Triangle tri;
 boolean autoRotate = true;
 PVector closest = null;
 
 
 void setup(){
 //Set up renderer
 size(1280,720, P3D);
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
 specular(100);
 bvh.draw();
 bvh.drawVertices();
 
 if(tri!=null){
 stroke(255,255,0);
 strokeWeight(6);
 beginShape(TRIANGLES);
 tri.draw();
 endShape();
 
 fill(255,128,0);
 noStroke();
 
 
 PVector p = tri.vertices[0].location;
 pushMatrix();
 translate(p.x,p.y,p.z);
 sphere(16);
 popMatrix();
 
 
 if(closest!=null){
 fill(128,255,0);
 pushMatrix();
 translate(closest.x,closest.y,closest.z);
 sphere(16);
 popMatrix();
 }
 
 
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
 
 closest = tri.getClosestPointTo(violet);
 println("Closest:");
 println(closest);
 }
 */
