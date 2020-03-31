import java.lang.Thread;

float dt = 1e-4;
float k = -1e+6;

int n = 1000;

Planet[] planets = new Planet[n];

ArrayList<PlanetBall> balls = new ArrayList<PlanetBall>();

float gridSize = 1;
HashMap<PVector, ArrayList<Planet>> grid = new HashMap<PVector, ArrayList<Planet>>();

float scaling = 1;
PVector screenPos;
final float sensativity = 0.1;

void setup()
{
    screenPos = new PVector(0, 0);
    //size(1920, 1080);
    fullScreen();

    for (int i = 0; i < n; ++i) {
        planets[i] = new Planet();
        gridSize = max(gridSize, planets[i].r);
    }
    
    for (Planet p1 : planets)
        balls.add(new PlanetBall().add(p1));

    //thread("upd");
    textSize(25);
}

void draw()
{
    background(110);

    translate(width/2, height/2); //to scale relative to the center of window
    scale(scaling);

    translate(screenPos.x - width/2, screenPos.y - height/2);
    
    //long start = System.nanoTime();

    //for(int i = 0; i < planets.length; ++i) {
    //    Planet p1 = planets[i];
    //    for (int j = i + 1; j < planets.length; ++j) {
    //        Planet p2 = planets[j];

    //        PVector gravity = gravity(p1, p2);
    //        PVector collision = collision(p1, p2);

    //        p1.df.add(gravity).add(collision.div(dt));
    //        p2.df.sub(gravity).sub(collision);
    //    }
    //}

    //for(Planet p : planets)
    //    p.update();
        
    //dt = (System.nanoTime() - start) * 1e-12;

    //for(Planet p : planets)
    //    p.display();
    
    for(int i = 0; i < balls.size(); ++i) {
        PlanetBall b1 = balls.get(i);
        for (int j = i + 1; j < balls.size(); ++j) {
            PlanetBall b2 = balls.get(j);

            PVector gravity = gravity(b1.ball, b2.ball);

            b1.ball.df.add(gravity);
            b2.ball.df.sub(gravity);
        }
    }
    
    for(PlanetBall b : balls) {
      b.update();
      b.display();
    }
    
    translate(width/2-screenPos.x, height/2-screenPos.y);
    scale(1/scaling);
    translate(- width/2, - height/2);
    
    text(frameRate, 50, 50);
    text(1/dt, 50, 100);
}

int t = 0;
void upd() {
    final int n = 4;

    while(true) {
        long start = System.nanoTime();

        Thread[] threads = new Thread[n];

        for (int k = 0; k < n; ++k)
        {
            t = k;
            threads[k] = new Thread(new Runnable(){
                final int p = t;
                public void run() {
                    for(int i = floor(planets.length * p / n); i < floor(planets.length * (p + 1) / n); ++i) {
                        Planet p1 = planets[i];
                        for (int j = i + 1; j < planets.length; ++j) {
                            Planet p2 = planets[j];

                            PVector gravity = gravity(p1, p2);
                            PVector collision = collision(p1, p2);

                            p1.df.add(gravity).add(collision.div(dt));
                            p2.df.sub(gravity).sub(collision);
                        }
                    }
                }
            });
            threads[k].start();
        }

        try {
            for(Thread t : threads)
                t.join();
        } catch (InterruptedException e) { }

        for(Planet p : planets)
            p.update();
        
        dt = (System.nanoTime() - start) * 1e-12;
    }
}

PVector gravity(Planet p1, Planet p2) {
    PVector d = PVector.sub(p1.pos, p2.pos);
    float dSq = d.magSq();

    if(dSq > sq(p1.r + p2.r) / 4)
        return d.normalize().mult(k * p1.m * p2.m/dSq);
    else return new PVector(0,0);
}

PVector collision(Planet p1, Planet p2) {
    PVector d = PVector.sub(p1.pos, p2.pos);
    float dist = d.mag();
    float k = ((p1.r + p2.r) / 2 - dist) / 2;

    if(k >= 0) {
        d.normalize();
        PVector c = d.copy().mult(k);
        p2.pos.sub(c);
        p1.pos.add(c);

        float dvX = - 2 * p1.m * p2.m * PVector.sub(p2.vel, p1.vel).dot(d) / (p1.m + p2.m);

        return new PVector(- dvX * d.x, dvX * d.y);
    }
    else return new PVector(0,0);
}

void mouseWheel(MouseEvent event) {
    float delta = event.getCount();
    scaling *= 1 - delta * sensativity;
}

void mouseDragged() {
  screenPos.x += (mouseX - pmouseX) / scaling;
  screenPos.y += (mouseY - pmouseY) / scaling;
}
