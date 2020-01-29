RGBDImage img;

void setup(){
  size(640,480); //<>// //<>//
  img = loadRGBDImage(2);
}
void draw(){
  if(mousePressed){ //<>// //<>//
    image(img.getRGBImage(), 0, 0);    
  }
  else{
    image(img.getDepthImage(), 0, 0);
  }
}
