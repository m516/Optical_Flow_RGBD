interface CoordinateManager {
  PVector anglesToImage(PVector angles);
  PVector imageToAngles(PVector image);
}


class EquiangularCoordinateManager implements CoordinateManager {
  //Number of pixels in image
  float imageWidth;
  float imageHeight;
  //FOV in radians
  float fovWidth;
  float fovHeight;

  public EquiangularCoordinateManager(float imageWidth, float imageHeight, float fovWidth, float fovHeight)
  {
    //Number of pixels in image
    this.imageWidth = imageWidth;
    this.imageHeight = imageHeight;
    //FOV in radians
    this.fovWidth = fovWidth;
    this.fovHeight = fovHeight;
  }

  /*
    Get image coordinates for a certain set of angles.
   
   The angles are in radians and the zero vector is at the center
   of the image.
   
   Positive x values are to the left of the image.
   Positive y values are to the bottom of the image.
   
   Returned coordinates are relative to the image's origin at (0,0)
   which is the upper left hand corner.
   */
  PVector anglesToImage(PVector angles) {
    PVector ret = angles.copy();
    ret.x += fovWidth/2.;
    ret.y += fovHeight/2.;
    ret.x *= imageWidth/fovWidth;
    ret.y *= imageHeight/fovHeight;
    return ret;
  }

  /*
    Get angular coordinates for a certain pixel in an image.
   
   Coordinates are relative to the image's origin at (0,0)
   which is the upper left hand corner.
   
   Positive x values are to the left of the image.
   Positive y values are to the bottom of the image.
   
   The returned angles are in radians and the zero vector is at the center
   of the image.
   */
  PVector imageToAngles(PVector imageCoords) {
    PVector ret = imageCoords.copy();
    ret.x -= imageWidth/2.;
    ret.y -= imageHeight/2.;
    ret.x *= fovWidth/imageWidth;
    ret.y *= fovHeight/imageHeight;
    return ret;
  }
}
