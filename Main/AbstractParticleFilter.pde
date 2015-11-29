import java.util.*;

abstract class AbstractParticleFilter {
  private List<Particle> particles;
  private Random random;

  public AbstractParticleFilter(int n, PImage initImage) {
    particles = new ArrayList<Particle>();
    for (int i = 0; i < n; i++) {
      particles.add(new Particle(0, 0, 0.0));
    }

    random = new Random(System.currentTimeMillis());

    init(initImage);
  }

  // Implement this method
  abstract protected double likelihood(int x, int y, PImage image);

  public void update(PImage image) {
    resample();
    predict();
    weight(image);
  }

  public void drawParticles() {
    stroke(#ff0000);
    strokeWeight(2);

    for (int i = 0; i < particles.size(); i++) {
      point(particles.get(i).x, particles.get(i).y);
    }
  }

  public void drawRectangle() {
    Particle result = measure();

    final int width = 30;
    final int height = 30;

    final int top = result.y - height / 2;
    final int bottom = result.y + height / 2;
    final int left = result.x - width / 2;
    final int right = result.x + width / 2;

    stroke(#ff0000);
    strokeWeight(4);

    line(left, top, right, top);
    line(left, bottom, right, bottom);
    line(left, top, left, bottom);
    line(right, top, right, bottom);
  }

  private void init(PImage image) {
    Particle maxParticle = new Particle(0, 0, 0.0);
    //----------------------------------------------------------------
    println("image size: " + image.width + ", " + image.height);
    //----------------------------------------------------------------
    for (int j = 0; j < image.height; j++) {
      for (int i = 0; i < image.width; i++) {
        double weight = likelihood(i, j, image);
        if (weight > maxParticle.weight) {
          maxParticle = new Particle(i, j, weight);
        }
      }
    }

    //----------------------------------------------------------------
    println("max weight: " + maxParticle.weight);
    println("at (" + maxParticle.x + ", " + maxParticle.y + ")");
    //----------------------------------------------------------------

    for (int i = 0; i < particles.size(); i++) {
      particles.set(i, new Particle(maxParticle.x, maxParticle.y, maxParticle.weight));
    }
  }

  private void resample() {
    List<Double> weights = new ArrayList<Double>();

    weights.add(particles.get(0).weight);
    for (int i = 1; i < particles.size(); i++) {
      weights.add(weights.get(i - 1) + particles.get(i).weight);
    }

    List<Particle> tmpParticles = new ArrayList<Particle>();
    for (int i = 0; i < particles.size(); i++) {
      tmpParticles.add(new Particle(particles.get(i).x, particles.get(i).y, particles.get(i).weight));
    }

    for (int i = 0; i < particles.size(); i++) {
      double weight = random.nextDouble() * weights.get(weights.size() - 1);
      int n = 0;
      while (weights.get(++n) < weight);
      particles.set(i, tmpParticles.get(n));
      particles.get(i).weight = 1.0;
    }
  }

  private void predict() {
    final double variance = 2.0;

    for (int i = 0; i < particles.size(); i++) {
      double vx = random.nextGaussian() * variance;
      double vy = random.nextGaussian() * variance;
      //----------------------------------------------------------------
      //println("v[" + i + "] = (" + (int) vx + ", " + (int) vy + ")");
      //----------------------------------------------------------------

      particles.get(i).x += (int) vx;
      particles.get(i).y += (int) vy;

      //----------------------------------------------------------------
      println("p[" + i + "] = (" + particles.get(i).x + ", " + particles.get(i).y + ")");
      //----------------------------------------------------------------
    }
  }

  private void weight(PImage image) {
    double sumWeight = 0.0;
    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).weight = likelihood(particles.get(i).x, particles.get(i).y, image);
      sumWeight += particles.get(i).weight;
    }

    for (int i = 0; i < particles.size(); i++) {
      particles.get(i).weight = (particles.get(i).weight / sumWeight) * particles.size();
      println("p[" + i + "].weight = " + particles.get(i).weight);
    }
  }

  private Particle measure() {
    double x = 0.0;
    double y = 0.0;
    double weight = 0.0;

    for (int i = 0; i < particles.size(); i++) {
      x += particles.get(i).x * particles.get(i).weight;
      y += particles.get(i).y * particles.get(i).weight;
      weight += particles.get(i).weight;
    }

    return new Particle((int) (x / weight), (int) (y / weight), 1.0);
  }
}