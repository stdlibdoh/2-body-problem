/**
 * Created by Michelle on 29/06/2017.
 */

import processing.core.*;

public class Astrobody {
    PVector acceleration = new PVector(0, 0, 0);
    PVector velocity;
    PVector positionPlanet = new PVector(0, 0, 0);
    PVector d = new PVector(0, 0, 0);
    PApplet parent;

    float G = (float) 6.67300e-11;
    float starMass = (float) 1.989e30;
    //float planetMass=5.972e15;
    float deltaT = (float) 0.001;
    float xPos;
    float yPos;
    float diameter;
    float scaleX = 10000000;
    float scaleY = 10000000;

    Astrobody(PApplet p) {
        parent = p;
    }

    void create(float diameter) {
        parent.ellipse(xPos, yPos, diameter, diameter);
    }

    void size(float tempDiam)
    {
        positionPlanet = new PVector (xPos*scaleX, yPos*scaleY);
        tempDiam = 2 * ((float) Math.sqrt(Math.pow((parent.mouseX-xPos), 2) + Math.pow((parent.mouseY-yPos), 2)));
        parent.ellipse(xPos, yPos, tempDiam, tempDiam);
        diameter = tempDiam;
    }

    void velocity()
    {
        parent.stroke(255);
        parent.line(xPos, yPos, parent.mouseX, parent.mouseY);
        parent.translate(xPos, yPos);
        velocity = new PVector((float) Math.pow(parent.mouseX-xPos, 3), (float) Math.pow(parent.mouseY-yPos, 3));
        parent.noStroke();
    }

    void move(PVector pStar)
    {
        d.set(pStar.x-positionPlanet.x, pStar.y-positionPlanet.y);
        acceleration=d.copy();
        acceleration.setMag(G*starMass/d.magSq());
        velocity.set(velocity.x+acceleration.x*deltaT, velocity.y+acceleration.y*deltaT);
        positionPlanet.set(positionPlanet.x+velocity.x*deltaT, positionPlanet.y+velocity.y*deltaT);
        xPos=positionPlanet.x/scaleX;
        yPos=positionPlanet.y/scaleY;
        parent.ellipse(xPos, yPos, diameter, diameter);
        deltaT+=0.5;
    }

    void setPos(float x, float y) {
        xPos = x;
        yPos = y;
    }
}
