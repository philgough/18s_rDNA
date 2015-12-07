//////////////////////////////////////////
//        Graph Variables               //
//////////////////////////////////////////
PImage p5Img, medImg, p95Img;



//////////////////////////////////////////
//        Graph Setup                   //
//////////////////////////////////////////
// some setup is done in organism class
void graphSetup() 
{

  p5Img = loadImage("happyIcon.png");
  medImg = loadImage("midIcon.png");
  p95Img = loadImage("deadIcon.png");


  for (int i = 0; i < organism.size (); i++) 
  {
    Organism o = organism.get(i);
    o.graph.drawGraphShape();
  }
}

//////////////////////////////////////////
//        Graph Draw                    //
//////////////////////////////////////////
void drawGraphs()
{
  for (int i = 0; i < organism.size (); i++) 
  {
    Organism o = organism.get(i);
    o.drawGraphs();
  }
}






//////////////////////////////////////////
//        Graph Class                   //
//////////////////////////////////////////

class Graph 
{

  PVector location = new PVector(0, 0);
  PVector graphEnd = new PVector(0, 0);

  float graphLength = 200.0;
  float graphHeight = 14;

  color negativeColour, medColour, positiveColour;


  boolean positive;

  float p5, med, p95, pH, pollutionIndicator, indicator;

  float minpH, maxpH, minPollution, maxPollution;

  int type;

  PShape graphShape;


  Graph(PVector tempLocation, int tempType)
  {
    location.set(tempLocation);

    if (location.x + graphLength < _w)
    {
      graphEnd.set(location.x + graphLength, location.y);
    } else 
    {
      graphEnd.set(location.x - graphLength, location.y);
    }

    type = tempType;
  }

  void drawGraphShape() 
  {
    // ** create graph shape ** \\
    // set colours for vertices

    negativeColour = color(33, 96, 99);
    medColour = color(32, 58, 99);
    positiveColour = color(43, 96, 99);
    pollutionIndicator = 0;

    // draw the shape
    graphShape = createShape();
    graphShape.colorMode(HSB, 360, 100, 100, 100);
    graphShape.beginShape();
    graphShape.strokeWeight(14);
    graphShape.noFill();
    float scale;
    switch (type)
    {
    case 0 : // saltwater
      minpH = 6.8;
      maxpH = 8.4;

      // println("details for salt water organism: p5:" + p5 + ", p95:" + p95 );

      graphShape.stroke(negativeColour);
      graphShape.vertex(location.x, location.y);
      scale = map(p5, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(medColour);
      scale = map(med, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(positiveColour);
      scale = map(p95, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.vertex(graphEnd.x, graphEnd.y);

      indicator = map(pH, minpH, maxpH, location.x, graphEnd.x);


      break;

    case 1 : // clean water
      // +'ve Phosphorus reaction
      minPollution = 0.00;
      maxPollution = 0.08;

      graphShape.stroke(positiveColour);
      graphShape.vertex(location.x, location.y);
      scale = map(p5, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(medColour);
      scale = map(med, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(negativeColour);
      scale = map(p95, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.vertex(graphEnd.x, graphEnd.y);

      break;

    case 2 : // freshwater
      minpH = 6.8;
      maxpH = 8.4;

      // println("details for salt water organism: p5:" + p5 + ", p95:" + p95 );

      graphShape.stroke(positiveColour);
      graphShape.vertex(location.x, location.y);
      scale = map(p5, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(medColour);
      scale = map(med, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(negativeColour);
      scale = map(p95, minpH, maxpH, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.vertex(graphEnd.x, graphEnd.y);

      indicator = map(pH, minpH, maxpH, location.x, graphEnd.x);


      break;

    case 3 : // dirty water
      // +'ve Phosphorus reaction
      minPollution = 0.05;
      maxPollution = 0.35;

      graphShape.stroke(negativeColour);
      graphShape.vertex(location.x, location.y);
      scale = map(p5, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(medColour);
      scale = map(med, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.stroke(positiveColour);
      scale = map(p95, minPollution, maxPollution, 0, (graphEnd.x- location.x));
      graphShape.vertex(location.x + scale, location.y);

      graphShape.vertex(graphEnd.x, graphEnd.y);



      break;

    default :
      break;
    } // end switch


    graphShape.endShape();
  } // end constructor

  void drawGraph()
  {
    switch (type)
    {
    case 0 : // saltwater
      shape(graphShape);
      // text("pH: " + nf(pH, 0, 2), location.x +(graphEnd.x - location.x)/2, location.y + 20);
      fill(0);
      noStroke();
      triangle(indicator - 5, location.y - 15, indicator + 5, location.y - 15, indicator, location.y-5);
      // stroke(0);
      // strokeWeight(1);
      // println(indicator);
      line(indicator, location.y +  ((graphEnd.x- location.x) * 0.04), indicator, location.y+7);
      image(p95Img, location.x  +  ((graphEnd.x- location.x) * 0.04), location.y);
      image(p5Img, graphEnd.x -  ((graphEnd.x- location.x) * 0.04), location.y);
      //image(medImg, location.x + graphLength/2, location.y);

      break;

    case 1 : // clean water
      shape(graphShape);

      indicator = map(pollutionIndicator, 0, 360, graphEnd.x, location.x);

      noStroke();
      triangle(indicator - 5, location.y - 15, indicator + 5, location.y - 15, indicator, location.y-5);

      image(p5Img, location.x + ((graphEnd.x- location.x) * 0.04), location.y);
      image(p95Img, graphEnd.x - ((graphEnd.x- location.x) * 0.04), location.y);

      break;

    case 2 : // freshwater
      shape(graphShape);
      // text("pH: " + nf(pH, 0, 2), location.x + (graphEnd.x - location.x)/2, location.y + 20);
      fill(0);
      noStroke();
      triangle(indicator - 5, location.y - 15, indicator + 5, location.y - 15, indicator, location.y-5);
      line(indicator, location.y +  ((graphEnd.x- location.x) * 0.04), indicator, location.y+7);
      image(p5Img, location.x  +  ((graphEnd.x- location.x) * 0.04), location.y);
      image(p95Img, graphEnd.x -  ((graphEnd.x- location.x) * 0.04), location.y);

      break;

    case 3 : // dirty water
      shape(graphShape);
      indicator = map(pollutionIndicator, 0, 360, location.x, graphEnd.x);

      noStroke();
      triangle(indicator - 5, location.y - 15, indicator + 5, location.y - 15, indicator, location.y-5);

      image(p95Img, location.x  + ((graphEnd.x - location.x) * 0.04), location.y);
      image(p5Img, graphEnd.x -  ((graphEnd.x- location.x) * 0.04), location.y);
      break;

    default :
      break;
    } // end switch
  } // end drawGraph
} // end class