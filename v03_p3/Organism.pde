//////////////////////////////////////////
//       Organism Variables             //
//////////////////////////////////////////
import PoissonPoints.*;

ArrayList<Organism> organism;



//////////////////////////////////////////
//       Organism Setup                 //
//////////////////////////////////////////

void organismSetup() 
{
  organism = new ArrayList<Organism>();
  println("organism class setup");


  // poisson disc distribution
  PoissonPoints pp = new PoissonPoints(this, 2000, 35, 30);

  println("number of organisms: " + pp.numLocations());

  for (int i = 0; i < pp.ppLocations.length; i++) 
  {
    if (estuary.insideRiver(pp.getPPLocation(i))) 
    {
      organism.add(new Organism(i%4, pp.getPPLocation(i), i));
    } // end if
  } // end for
} // end setup

//////////////////////////////////////////
//       Organism Draw                  //
//////////////////////////////////////////

void drawOrganisms() 
{
  for (int i = 0; i < organism.size (); i++) 
  {
    Organism o = organism.get(i);
    o.run();
  }
} // end draw


void organismsForWelcomeScreen(int type, float x, float y, float s)
{
  Organism o = new Organism(type, x, y, s);
}





//////////////////////////////////////////
//       Organism Class                 //
//////////////////////////////////////////

class Organism 
{
  // What kind of organism
  int type;
  int id; 

  // where it is located
  PVector location = new PVector(0, 0);

  // settings
  float outerCircleDiam = 12;
  float innerCircleDiam = 7;
  float arcDiam = 14;

  boolean drawGraphNow = false;

  Graph graph;


  int lastPollutionReactionTime = millis();
  float pollutionReactionTimerRate, z;
  float colorScale = 360;

  color arcFill[] = {
    color(7, 85, 88), color(47, 89, 77), color(311, 52, 68), color(176, 86, 79)
  };

  float pH;

  // organism for use in the welcome screen
  Organism(int tempType, float xPos, float yPos, float s) {
    colorScale = s;
    type = tempType;
    z = 20;
    location.set(xPos, yPos);

    graph = new Graph(location, type);

    checkWaste();
    render();
  }


  // organism for use in the main state
  Organism(int tempType, PVector tempLocation, int tempID) 
  {
    type = tempType;
    location.set(tempLocation);
    id = tempID ;


    // the graph
    graph = new Graph(location, type);
  } // end constructor

  void finalOrganismSetup() {

    if (location.x < 0.5 * _w) {
      pH = 6.8;
    } else {
      if (location.x < 0.75 * _w) {
        pH = 8.4 - location.x/(0.75 * _w);
      } else {
        pH = 8.4;
      }
    }
    graph.pH = pH;

    float scale = 0;
    switch (type)
    {
    default :
      break;
    case 2 : // freshwater
      scale = map(pH, graph.p5, graph.p95, -360, 0);
      colorScale -= scale;
      break;
    case 0 : // saltwater
      scale = map(pH, graph.p5, graph.p95, 0, -360);
      colorScale -= scale;
      break;
    }
    // println(scale + ": " + type);
    // println(pH + " " + graph.p5 + " " + graph.p95);
  }

  void run() 
  {
    update();
    render();
  } // end run()


  void update() 
  {
    for (Map.Entry entry : leapObject.entrySet ())
    {
      // the object's entry in the map and an object to store it:
      //Integer entryKey = (Integer) entry.getKey();
      LeapObject object = (LeapObject) entry.getValue();
      // check if it is valid
      if (object.isValid)
      {
        // object is valid, check to see if it is close enough
        if (location.dist(object.handPosition) < innerCircleDiam * 2) 
        {
          //          showHint(2);
          currentHint = 2;
          if (object.numExtendedFingers == 2) 
          {
            // println("selecting " + id);
            // graph.drawGraph();
            drawGraphNow = true;
          }
        } // end if object is too close to organism
      } // end if object is valid
    } // end for each entry in the map
    checkWaste();
  } // end update



    void checkWaste()
  {
    // update how happy the organism is
    if (type == 1 || type == 3)
      // if reacts to pollution
    {
      float numWasteShapesCoveringTheOrganism = 0;

      for (int i = 0; i < pollution.size (); i++)
      {
        Pollution p = pollution.get(i);
        if (p.insideWasteShape(location)) {

          numWasteShapesCoveringTheOrganism ++;
        } // end if inside shape
      } // end for loop



      switch(type)
        // type == 1, <3's clean water
      { 
      default:
        break;
      case 1:
        if (numWasteShapesCoveringTheOrganism > 0) 
          // organism is has waste over it
        {
          if (colorScale > 0) {
            // if it's not already totally depressed
            colorScale -= numWasteShapesCoveringTheOrganism * z/20;
          } else 
          {
            colorScale = 0;
          }
        } else 
          // no shapes over the organism
        {
          if (colorScale < 360)
            // if it's not already totes happy about it
          {
            colorScale += z/20;
          } else 
          {
            colorScale = 360;
          } // end happiness adjustment
        } // end if shapes over type == 1
        graph.pollutionIndicator = colorScale;
        // end type == 1 
        break;
      case 3:
        // type == 3, <3's dirty water

        if (numWasteShapesCoveringTheOrganism > 0)
          // shapes cover the organism
        {
          if (colorScale < 360)
            // if it's not at peak happines,...
          {
            colorScale += numWasteShapesCoveringTheOrganism *  z/20;
          } else {
            colorScale = 360;
          }
        } else
          // no shapes over the organism
        {
          if (colorScale > 0)
            // if not too sad
          {
            colorScale -= z/20;
          } else 
          {
            colorScale = 0;
          } // end adjust happiness level
        } // end if covered by waste
        graph.pollutionIndicator = colorScale;
        break;
      } // end switch
    } // end if reacts to pollution
  } // end checkWaste

  void render() 
  {
    // outer circle
    // else 
    //{
    //  noStroke();
    //}
    //fill(250);
    //ellipse (location.x, location.y, outerCircleDiam, outerCircleDiam);

    // arc


    noStroke();
    fill(235, 52 + colorScale/10, 62 + colorScale/10, 60 + colorScale/20);

    ellipse(location.x, location.y, outerCircleDiam, outerCircleDiam);
    fill(arcFill[type]);
    float arcPos =type * HALF_PI - QUARTER_PI; 
    arc(location.x, location.y, arcDiam, arcDiam, arcPos, arcPos + HALF_PI);

    // inner circle and text
    stroke(colorScale);
    strokeWeight(innerCircleDiam);
    strokeCap(ROUND);
    point(location.x, location.y);
  } // end render()

  void drawGraphs()
  {
    if (drawGraphNow)
    {
      // println("drawing the graph");
      noStroke();
      fill(0);
      float arcPos =type * HALF_PI - QUARTER_PI; 
      arc(location.x, location.y, outerCircleDiam, outerCircleDiam, arcPos, arcPos + HALF_PI);
      stroke(120, 52 + colorScale/10, 52 + colorScale/10);
      strokeWeight(innerCircleDiam);
      strokeCap(ROUND);
      point(location.x, location.y);
      graph.drawGraph();
      drawGraphNow = false;
    } // end if
  } // end drawGraphs
}// end class