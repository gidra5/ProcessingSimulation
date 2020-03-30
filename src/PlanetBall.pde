class PlanetBall {
  ArrayList<Planet> planets = new ArrayList<Planet>(); 
  Planet ball = new Planet();
  
  PlanetBall() {}
   
  void display() {
    for(Planet p : this.planets)
      p.display();
  }
   
  void update() {
    ball.update();
    
    PVector change = PVector.sub(ball.pos, ball.prevPos);
    
    for (Planet p: this.planets) {
      p.pos.add(change);
      
      for(int i = 0; i < planets.size(); ++i) {
        Planet p1 = planets.get(i);
        for (int j = i + 1; j < planets.size(); ++j) {
          Planet p2 = planets.get(j);

          PVector gravity = gravity(p1, p2);
          PVector collision = collision(p1, p2);

          p1.df.add(gravity).add(collision.div(dt));
          p2.df.sub(gravity).add(collision.div(dt));
        }
      }
    }
  }
  
  PlanetBall add(Planet p) {
    planets.add(p);
    
    ball.pos.mult(ball.m).add(p.pos.copy().mult(p.m));
    ball.m += p.m;
    ball.pos.div(ball.m);
    
    return this;
  }
}
