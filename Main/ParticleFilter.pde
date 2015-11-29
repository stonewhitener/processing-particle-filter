class ParticleFilter extends AbstractParticleFilter {

  public ParticleFilter(int n, PImage initImage) {
    super(n, initImage);
  }

  @Override
  protected double likelihood(int x, int y, PImage image) {
    final int width = 30;
    final int height = 30;

    int count = 0;
    for (int j = y - height / 2; j < y + height / 2; j++) {
      for (int i = x - width / 2; i < x + width / 2; i++) {
        if (isInImage(i, j, image) && isYellow(image.get(i, j))) {
          count++;
        }
      }
    }

    if (count == 0) {
      return 0.0001;
    } else {
      return (double) count / (width * height);
    }
  }

  private boolean isInImage(int x, int y, PImage image) {
    return (0 <= x && x < (int) image.width && 0 <= y && y < (int) image.height);
  }

  private boolean isRed(color c) {
    return (red(c) > 200 && green(c) < 100 && blue(c) < 100);
  }

  private boolean isGreen(color c) {
    return (red(c) < 100 && green(c) > 200 && blue(c) < 100);
  }

  private boolean isBlue(color c) {
    return (red(c) < 100 && green(c) < 100 && blue(c) > 200);
  }

  private boolean isYellow(color c) {
    return(red(c) > 200.0 && green(c) > 200.0 && blue(c) < 150.0);
  }

  private boolean isBlack(color c) {
    return (red(c) < 64 && green(c) < 64 && blue(c) < 64);
  }

  //@Override
  //protected double likelihood(int x, int y, PImage image) {
  //  float r, g, b;
  //  float dist = 0.0, sigma = 50.0;

  //  r = red(image.get(x, y));
  //  g = green(image.get(x, y));
  //  b = blue(image.get(x, y));

  //  dist = sqrt (b * b + g * g + (0 - r) * (0 - r));

  //  return 1.0 / (sqrt (2.0 * PI) * sigma) * exp (-dist * dist / (2.0 * sigma * sigma));
  //}
}