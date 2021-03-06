class RGBDImage{
  
  public static final String rgbImagePrefix = "renders/color/";
  public static final String rgbImageSuffix = ".png";
  public static final String depthImagePrefix = "renders/depth/Image";
  public static final String depthImageSuffix = ".png";
  
  PImage rgb;
  PImage depth;
  
  PVector location;
  PVector rotation;
  
  float min = 2.2;
  float max = 6.4;
  
  public RGBDImage(PImage rgb, PImage depth){
    this.rgb = rgb;
    this.depth = depth;
  }
  
  public PImage getRGBImage(){
    return rgb;
  }
  
  public PImage getDepthImage(){
    return depth;
  }
  
  public float getDepthAt(float x, float y){
    color c = depth.get(int(x), int(y));
    return map(red(c),0,255,min,max);
  }
  
  public color getColorAt(float x, float y){
    return rgb.get(int(x), int(y));
  }
}

RGBDImage loadRGBDImage(int n){
    //Load the RGB image
    //Get the filename
    StringBuilder sb = new StringBuilder();
    sb.append(RGBDImage.rgbImagePrefix);
    if(n<1000) sb.append("0");
    if(n<100) sb.append("0");
    if(n<10) sb.append("0");
    sb.append(n);
    sb.append(RGBDImage.rgbImageSuffix);
    //Load the image
    PImage rgb = loadImage(sb.toString());
    
    
    //Load the depth image
    //Get the filename
    sb.setLength(0);
    sb.append(RGBDImage.depthImagePrefix);
    if(n<1000) sb.append("0");
    if(n<100) sb.append("0");
    if(n<10) sb.append("0");
    sb.append(n);
    sb.append(RGBDImage.depthImageSuffix);
    //Load the image
    PImage depth = loadImage(sb.toString());
    
    RGBDImage pic = new RGBDImage(rgb, depth);
    return pic;
  }
