class Planet extends Drawable
{
    volatile PVector vel, acc, dp, df;
    PVector prevPos;

    float m;

    Planet()
    {
        super();

        pos = new PVector(random(0, width), random(0, height));
        vel = new PVector(0, 0);
        prevPos = pos.copy();
        acc = new PVector(0, 0);

        df = new PVector(0, 0);
        dp = new PVector(0, 0);

        m = 2000 * 100 / n;//random(50,200);

        r = sqrt(m);
    }

    void update()
    {
        //vel.add(dp.div(m));
        acc.add(df.div(m).add(dp.div(dt)));

        // 1
        // vel.add(PVector.mult(acc, dt));
        // pos.add(PVector.mult(vel, dt)).add(PVector.mult(acc, dt*dt/2));

        // 2
        // vel.add(PVector.mult(acc, dt));
        // pos.add(PVector.mult(vel, dt));

        // 3
        PVector temp = pos.copy();
        pos.add(pos).sub(prevPos).add(PVector.mult(acc, dt * dt));
        prevPos = temp;

        df = new PVector(0, 0);
        //dp = new PVector(0, 0);

        pos.x = max(min(pos.x, width), 0);
        pos.y = max(min(pos.y, height), 0);

        if(pos.x == width || pos.x == 0)
            vel.x = -vel.x;

        if(pos.y == height || pos.y == 0)
            vel.y = -vel.y;

        acc = new PVector(0, 0);
    }
}
