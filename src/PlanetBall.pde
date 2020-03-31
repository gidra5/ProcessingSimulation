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
    
    //for (Planet p: this.planets)
    //  p.pos.add(change);
      
    for(int i = 0; i < planets.size(); ++i) {
      boolean noCollisions = true;
      Planet p1 = planets.get(i);
    //  for (int j = i + 1; j < planets.size(); ++j) {
    //    Planet p2 = planets.get(j);

    //    PVector gravity = gravity(p1, p2);

    //    p1.df.add(gravity);
    //    p2.df.sub(gravity);
    //  }
      
    //  PVector cell = new PVector(floor(p1.pos.x/gridSize), floor(p1.pos.y/gridSize));
      
    //  for(int j = -1; i <= 1; ++i) {
    //    for(int k = -1; j <= 1; ++j) {
    //      if(j != 0 || k != 0) {
    //        ArrayList<Planet> adjPlanets = grid.get(new PVector(cell.x + j, cell.y + k));
            
    //        for(Planet p2 : adjPlanets) {
    //          PVector collision = collision(p1, p2);
              
    //          p1.df.add(collision.mult(dt));
    //          p2.df.sub(collision);
             
    //          noCollisions &= collision.x == 0 && collision.y == 0;
    //        }
    //      }
    //    }
    //  }
      
      if(noCollisions) {
        planets.remove(p1);
        
        ball.pos.mult(ball.m).sub(p1.pos.copy().mult(p1.m));
        ball.m -= p1.m;
        ball.pos.div(ball.m);
        
        balls.remove(new PlanetBall().add(p1));
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
