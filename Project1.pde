Astrobody planet;                                                                                  // Object 'planet' declaration, as part of the 'Astrobody' class
Astrobody star;                                                                                    // Object 'star' declaration, as part of the 'Astrobody' class

PImage background;                                                                                 // Image to be used as background.
PFont infobox;                                                                                     // Font to be used for the Information Box

float scaleX = 10000000;                                                                           // Multiplier on the X axis for the position of the bodies
float scaleY = 10000000;                                                                           // Multiplier on the Y axis for the position of the bodies

float xPos;                                                                                        // X position according to the size of the display window
float yPos;                                                                                        // Y position according to the size of the display window
float diameter;                                                                                    // Diameter of the planet
int clickCount = 0;                                                                                // Counter for number of clicks, or STAGEs of the program
boolean flag = false;                                                                              // Flag waiting for a mouse click
float tempDiam;                                                                                    // Temporary diameter to be updated at a later stage

PVector positionStar;                                                                              // Position Vector for the Star

void setup()
{
  size(1280, 960);                                                                                 // Size of the window
  smooth();                                                                                        // Anti-Aliasing ON
  planet = new Astrobody(xPos, yPos);                                                              // Initialises object 'planet' with starting coordinates
  //star = new Astrobody(width/2, height/2);                                                       // See BugTracker #1
  background = loadImage("bright_lights.jpg");                                                     // Loads image to be used as the background. Source: https://www.nasa.gov
  infobox = createFont("OCRAExtended-48.vlw", 15, true);                                           // Creates font to be used in the Information Box, with size 15, and anti-aliasing ON
  textFont(infobox);                                                                               // Loads font to 'infobox' variable
  rectMode(CORNERS);                                                                               // Sets rect() to take opposite corners
  noStroke();                                                                                      
  frameRate(30);                                                                                   // Halves framerate to smooth movement
}

void draw()
{
  cursor(CROSS);                                                                                   // Sets cursor to be a cross, rather than a pointer
  image(background, 0, 0);                                                                         // (Re)draws background image
  fill(0, 0, 0, 120);                                                                              // Sets colour of following rectangle, to be used as the Information Box
  rect(850, 800, 1280, 960);                                                                       // Creates rectangle to be used as the Information Box
  fill(255);                                                                                       // Sets colour of font
  textAlign(CENTER);                                                                               // Sets alignment of font
  textSize(15);                                                                                    // Re(sets) size of font
  text("INFO-BOX", 1060, 825);                                                                     // Writes 'INFO-BOX' to the display window
  textAlign(LEFT);                                                                                 // Sets alignemtn of font
  textSize(13);                                                                                    // Sets size of font
  text("Position of the Planet is "+int(xPos)+"x10^7, "+int(yPos)+"x10^7", 865, 855);              // Writes following to the display window
  fill(234, 200, 26);                                                                              // Sets colour of the Star
  ellipse(width/2, height/2, 50, 50);                                                              // Creates Star
  //star.create(50);                                                                               // See BugTracker #1
  positionStar = new PVector ((width/2)*scaleX, (height/2)*scaleY);                                // Creates Position Vector for the Star

  if (mousePressed)
  {
    flag=true;                                                                                     // Sets 'flag' to true
  }

  if (flag)
  {
    fill(0, 0, 255);                                                                               // Sets colour of the planet
    if (clickCount==0)                                                                             // Initial STAGE
    {
      xPos=mouseX;                                                                                 // Assigns mouse input along the X axis to be the X position of the center of the planet
      yPos=mouseY;                                                                                 // Assigns mouse input along the Y axis to be the Y position of the center of the planet
      planet.create(1);                                                                            // Creates planet with a temporary diameter of '1'
    }
    if (clickCount==1)                                                                             // STAGE 1
    {
      noCursor();                                                                                  // Sets cursor to invisible.
      planet.size(tempDiam);                                                                       // Sets the planet size according to the temporary diameter
    }
    pushMatrix();                                                                                  // Saves current coordinate referential
    if (clickCount==2)                                                                             // STAGE 2
    {
      planet.create(diameter);                                                                     // Creates planet with the permanent diameter
      planet.velocity();                                                                           // Sets initial velocity of the planet
    }
    popMatrix();                                                                                   // Loads previously saved coordinate referential
    if (clickCount==3)                                                                             // STAGE 3
    {
      noCursor();                                                                                  // Sets cursor to invisible
      planet.create(diameter);                                                                     // Creates planet with the permanent diameter
      planet.move();                                                                               // Initialises movement of the planet
    }
  }
}

class Astrobody
{
  PVector acceleration = new PVector(0, 0, 0);                                                     // Acceleration Vector, initialised at 0
  PVector velocity;                                                                                // Velocity Vector
  PVector positionPlanet = new PVector(0, 0, 0);                                                   // Position Vector for the Planet
  PVector d = new PVector(0, 0, 0);                                                                // Vector for the position between Planet and Star

  float G=6.67300e-11;                                                                             // Gravitational Constant
  float starMass=1.989e30;                                                                         // Mass for the Star
  //float planetMass=5.972e15;                                                                     // Not used in current iteration of simulation
  float deltaT=0.001;                                                                              // Variable representing Time
  
  Astrobody(float x, float y)
  {
    xPos=x;                                                                                        // Assigns variable X to be xPos used as a global variable
    yPos=y;                                                                                        // Assigns variable Y to be yPos used as a global variable
  }

  void create(float diameter)                                                                      // Method that creates the body, with diameter being the input
  {
    ellipse(xPos, yPos, diameter, diameter);                                                       // Creates an ellipse with the following parameters
  }

  void size(float tempDiam)                                                                        // Method that defines the size of the body, temporary diameter being the input
  {
    positionPlanet = new PVector (xPos*scaleX, yPos*scaleY);                                       // Defines the Vector position of the Planet
    tempDiam=2*(sqrt(sq(mouseX-xPos)+sq(mouseY-yPos)));                                            // Calculates the diameter using the Pythagoras' theorem and multiplying it by 2
    ellipse(xPos, yPos, tempDiam, tempDiam);                                                       // Creates an ellipse with the following parameters
    diameter=tempDiam;                                                                             // Assigns the temporary diameter to be the permanent diameter
  }

  void velocity()                                                                                  // Method to define the initial velocity of the body
  {
    stroke(255);                                                                                   // Defines colour of the line representing the velocity vector
    line(xPos, yPos, mouseX, mouseY);                                                              // Creates the line representing the velocity vector
    translate(xPos, yPos);                                                                         // Sets a new referential with the origin being the origin of the body
    velocity = new PVector(pow(mouseX-xPos, 3), pow(mouseY-yPos, 3));                              // Defines the velocity vector with an added multiplier
    noStroke();                                                                                    
  }

  void move()                                                                                      // Method to move the body
  {
    d.set(positionStar.x-positionPlanet.x, positionStar.y-positionPlanet.y);                       // (Re)sets the position vector of planet-star
    acceleration=d.copy();                                                                         // Copies the d vector to maintain direction
    acceleration.setMag(G*starMass/d.magSq());                                                     // Sets acceleration vector's magnitude according to the Newton's 2nd Law of motion and Newton's Law of Universal Gravitation
    velocity.set(velocity.x+acceleration.x*deltaT, velocity.y+acceleration.y*deltaT);              // Sets velocity vector
    positionPlanet.set(positionPlanet.x+velocity.x*deltaT, positionPlanet.y+velocity.y*deltaT);    // Sets Position Vector of the planet
    xPos=positionPlanet.x/scaleX;                                                                  // Removes the X Multiplier
    yPos=positionPlanet.y/scaleY;                                                                  // Removes the Y Multiplier
    ellipse(xPos, yPos, diameter, diameter);                                                       // (Re)draws the planet according to its motion
    deltaT+=0.5;                                                                                   // Increments Time by the 0.5 constant
  }
}


void mouseReleased()                                                                               // Function to increment clickCount in order to go to the next STAGE
{
  if (clickCount<3)                                                                                // Limits clickCount to 3
  {
    clickCount++;
  }
}


void keyPressed()                                                                                  // Function to go back to the previous STAGE by pressing BACKSPACE
{
  if (key==BACKSPACE)
  {
    clickCount--;
  }
}