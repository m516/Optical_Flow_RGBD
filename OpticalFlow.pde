class OpticalFlow1 {


  class ImageCoordinate {
    int x, y;
  }
  class WeighedImageCoordinate extends ImageCoordinate {
    float weight;
  }

  PImage resultImage;
  float[][] uniquenessOfPointsImage1;
  float[][] uniquenessOfPointsImage2;
  ImageCoordinate[] uniquePointsImage1;
  ImageCoordinate[] uniquePointsImage2;


  ImageCoordinate[][] results;

  void compute(RGBDImage im1, RGBDImage im2) {
    //Stage 1: Calculate uniqueness of pixels
    uniquenessOfPointsImage1 = calculateUniquenessOfEachPixel(im1);
    //uniquenessOfPointsImage2 = calculateUniquenessOfEachPixel(im2);

    //Create the image to draw
    resultImage = createImage(im1.rgb.width, im1.rgb.height, RGB);
    resultImage.loadPixels();
    for (int i = 0; i < resultImage.pixels.length; i++) {
      int x = i % resultImage.width;
      int y = i / resultImage.width;
      resultImage.pixels[i]=color(uniquenessOfPointsImage1[x][y]*256);
    }
    resultImage.updatePixels();
  }

  ImageCoordinate[] findLocallyUniquePixels(RGBDImage im) {
    return null; //TODO stub
  }

  float[][] calculateUniquenessOfEachPixel(RGBDImage im) {
    float[][] ret = new float[im.rgb.width][im.rgb.height];

    for (int i = 0; i < im.rgb.width; i++) {
      for (int j = 0; j < im.rgb.height; j++) {
        ret[i][j]=uniquenessOfPixel(im, i, j, 8);
      }
    }
    return ret;
  }

  float uniquenessOfPixel(RGBDImage im, int x, int y, int kernelSize) {
    if (x<kernelSize*2) return 0;
    if (y<kernelSize*2) return 0;
    if (x>=im.rgb.width-kernelSize*2) return 0;
    if (y>=im.rgb.height-kernelSize*2) return 0;

    im.rgb.loadPixels();


    float v2 = 0;
    float ret = 0;
    for (int i = x-kernelSize; i < x+kernelSize; i++) {
      for (int j = y-kernelSize; j < y+kernelSize; j++) {

        v2+=hue(fastGet(im.rgb, i, j))*hue(fastGet(im.rgb, i, j));
        //v2+=brightness(im.rgb.get(i, j))*brightness(im.rgb.get(i, j));
        v2+=saturation(fastGet(im.rgb, i, j))*saturation(fastGet(im.rgb, i, j));
        v2+=brightness(fastGet(im.rgb, i, j))*brightness(fastGet(im.rgb, i, j));

        float v1 = 0;
        for (int p = i-kernelSize; p < i+kernelSize; p++) {
          for (int q = j-kernelSize; q < j+kernelSize; q++) {
            v1+=hue(fastGet(im.rgb, i, j))*hue(fastGet(im.rgb, p, q));
            //v1+=brightness(im.rgb.get(i, j))*brightness(im.rgb.get(p, q));
            v1+=saturation(fastGet(im.rgb, i, j))*saturation(fastGet(im.rgb, p, q));
            v1+=brightness(fastGet(im.rgb, i, j))*brightness(fastGet(im.rgb, p, q));
          }
        }

        if (ret<v1)
          ret = v1;
      }
    }
    
    ret = abs(1.0-ret/v2);
    return ret; //<>//
  }

  private color fastGet(PImage img, int x, int y) {
    return img.pixels[y*img.width+x];
  }

  void drawUniquenessMap() {
    if (resultImage==null) return;
    image(resultImage, 0, 0);
  }
}
