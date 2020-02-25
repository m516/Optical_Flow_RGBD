import java.util.Iterator;

abstract class RGBDCamera{
  //Relative location and position of camera at this time
  PVector location;
  PVector rotation;
  
  //The size of the image taken from the camera
  PVector imageSize;
  
  //Get specs on a certain pixel
  abstract color getColorAtImage(float imageX, float imageY);
  abstract color getColorAtAngle(float theta,  float rho);
  abstract float getDepthAtImage(float imageX, float imageY);
  abstract float getDepthAtAngle(float theta,  float rho);
  
  //Attempt to capture a new image.
  //Return true if the operation succeeded and false otherwise
  abstract boolean capture();
  
  //Draws the image onto the renderer at the origin.
  //Can be translated, rotated, or scaled with PGraphics's methods.
  abstract void draw(PGraphics renderer);
  
  //DataPointIterator
  private DataPointIterator dataPointIterator;
  DataPointIterator getDataPointIterator(){
    return dataPointIterator;
  }
  
  
  class DataPoint{
    private RGBDCamera parent;
    private PVector imageCoordinates;
    
    private DataPoint(RGBDCamera parent, PVector imageCoordinates){
      this.parent = parent;
      this.imageCoordinates = imageCoordinates;
    }
    
    RGBDCamera getCamera(){return parent;}
    PVector getImageCoordinates(){return imageCoordinates;}
  }
  
  abstract class DataPointIterator implements Iterator{
    private RGBDCamera camera;
    DataPoint currentDataPoint;
    
    public RGBDCamera getCamera(){
      return camera;
    }
  }
}

  
class RGBDCameraSimulation extends RGBDCamera{
  public static final int NUM_FRAMES = 2;
  
  //The current image containing RGBD data
  RGBDImage currentImage;
  
  //The current image index
  private int index = 0;
  
  public RGBDCameraSimulation(){
    
  }
  
  public boolean capture(){
    //Don't attempt to load frames that haven't been rendered.
    if(index>=NUM_FRAMES) return false;
    
    //Try to load the next frame
    try{
    index++;
    currentImage = loadRGBDImage(index);
    }
    catch(Exception e){
      System.err.println("Failed to load image: " + e.getMessage());
      return false;
    }
    return true;
  }
  
  public color getColorAtImage(float imageX, float imageY){
    println("Called a stub in " + getClass());
    return #000000; //TODO Stub
  }
  public color getColorAtAngle(float theta,  float rho){
    println("Called a stub in " + getClass());
    return #000000; //TODO Stub
  }
  public float getDepthAtImage(float imageX, float imageY){
    println("Called a stub in " + getClass());
    return Float.NaN; //TODO Stub
  }
  public float getDepthAtAngle(float theta,  float rho){
    println("Called a stub in " + getClass());
    return Float.NaN; //TODO Stub
  }
  
  //Draws the image onto the renderer at the origin.
  //Can be translated, rotated, or scaled with PGraphics's methods.
  void draw(PGraphics renderer){
    renderer.image(currentImage.getRGBImage(), 0, 0);
  }
}
