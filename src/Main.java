/**
 * Created by Wilson on 29/06/2017.
 */

import processing.core.*;

public class Main extends PApplet {

    // Global Variables

    Astrobody planet;

    PImage background;
    PFont infobox;


    float tempDiam;

    PVector positionStar;

    boolean flag = false;
    int clickCount = 0;

    public static void main(String[] args) {
        PApplet.main("Main");
    }

    public void settings() {
        size(1280, 960);
        smooth();
    }

    public void setup() {
        planet = new Astrobody(this);
        background = loadImage("bright_lights.jpg");
        infobox = createFont("OCRAExtended-48.vlw", 15, true);
        textFont(infobox);
        rectMode(CORNERS);
        noStroke();
        frameRate(30);
    }

    public void draw() {
        displayText();
//        background(255);
        fill(234, 200, 26);
        ellipse(width / 2, height / 2, 50, 50);
        positionStar = new PVector((width / 2) * planet.scaleX, (height / 2) * planet.scaleY);

        if (mousePressed)
            flag = true;

        if (flag) {
            fill(0, 0, 255);
            if (clickCount == 0) {
                planet.setPos(mouseX, mouseY);
                planet.create(1);
            }
            if (clickCount == 1) {
                noCursor();
                planet.size(tempDiam);
            }
            pushMatrix();
            if (clickCount == 2) {
                planet.create(planet.diameter);
                planet.velocity();
            }
            popMatrix();
            if (clickCount == 3) {
                noCursor();
                planet.create(planet.diameter);
                planet.move(positionStar);
            }
        }
    }

    public void displayText() {
        cursor(CROSS);
        image(background, 0, 0);
        fill(0, 0, 0, 120);
        rect(850, 800, 1280, 960);
        fill(255);
        textAlign(CENTER);
        textSize(15);
        text("INFO-BOX", 1060, 825);
        textAlign(LEFT);
        textSize(13);
        text("Position of the Planet is " +Math.round(planet.xPos) + "x10^7, " +Math.round(planet.yPos) + "x10^7", 865, 855);
    }

    public void mouseReleased()
    {
        if (clickCount<3) {
            clickCount++;
        }
    }

    public void keyPressed() {
        if (key==BACKSPACE)
        {
            clickCount--;
        }
    }
}
