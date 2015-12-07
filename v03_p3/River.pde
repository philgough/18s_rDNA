//////////////////////////////////////////
//         River Variables              //
//////////////////////////////////////////

River estuary;
// PShape welcomeRiver;
color riverColor;
// PGraphics bg; // This is because the outline of the PShape is drawn over the leap cursor ellipse (?? was solved by using P2D instead of OPENGL??)


//////////////////////////////////////////
//         River Setup                  //
//////////////////////////////////////////

void riverSetup()
{
  // bg = createGraphics(_w, _h, OPENGL);
  estuary = new River();

  // welcomeRiver = drawWelcomeRiver();

  // bg.beginDraw();
  // bg.shape(estuary.river, 0, 0);
  // bg.endDraw();
  println("river setup done");
} // end riverSetup



//////////////////////////////////////////
//         River Class                  //
//////////////////////////////////////////

class River
{
  PShape river;

  River()
  {
    riverColor = color(205, 91, 97);
    river = createShape();
    river.beginShape();
    river.fill(riverColor);
    river.stroke(riverColor);
    river.strokeWeight(20);
    river.strokeJoin(BEVEL);
    // river.noStroke();
    river.curveVertex(0, _h/2 - 40); // start point, just above halfway on LHS
    for (float i = 0; i < _w*.75; i+= 100)
    {
      // alternate between up and down
      float yPos = _h/2 - 90 + (sin(radians(i/2)) * 50) + (randomGaussian() * 10);
      float xPos = i;

      river.fill(201 + random(6)-3, 91 + random(6)-3, 97 + random(6)-3);

      river.curveVertex(xPos, yPos);
      if (yPos < 0)
      { 
        return;
      } // end if
    } // end for loop
    river.curveVertex(_w * 0.7, 0);
    river.curveVertex(_w, 0);

    river.curveVertex(_w, _h);
    river.curveVertex(_w*0.7, _h);


    for (float i = _w*.75; i > -100; i-= 100)
    {
      // alternate between up and down
      float yPos = _h/2 + 90 + (sin(radians(i/2)) * 50) + (randomGaussian() * 10);
      float xPos = i;

      river.fill(201 + random(6)-3, 91 + random(6)-3, 97 + random(6)-3);

      river.curveVertex(xPos, yPos);
    } // end for loop


    river.curveVertex(0, _h/2 + 50);

    river.endShape();
  } // end constructor



  PShape riverShape() 
  {
    return river;
  }


  boolean insideRiver(PVector p) 
  {

    int n = river.getVertexCount();
    boolean c = false;
    int j = n-1;
    for (int i = 0; i < n; j = i++) 
    {
      PVector a = river.getVertex(i);
      PVector b = river.getVertex(j);
      if (((a.y > p.y) != (b.y > p.y)) && (p.x < (b.x - a.x) * (p.y - a.y) / (b.y - a.y) + a.x)) 
      {
        c = !c;
      } // end if statement
    }  // end for loop
    return c;
  }  // end boolean insideRiver



  boolean insideRiver(float x, float y) 
  {

    int n = river.getVertexCount();
    boolean c = false;
    int j = n-1;
    for (int i = 0; i < n; j = i++) 
    {
      PVector a = river.getVertex(i);
      PVector b = river.getVertex(j);
      if (((a.y > y) != (b.y > y)) && (x < (b.x - a.x) * (y - a.y) / (b.y - a.y) + a.x)) 
      {
        c = !c;
      } // end if statement
    }  // end for loop
    return c;
  }  // end boolean insideRiver
} // end river class


//////////////////////////////////////////
//         Welcome screen river         //
//////////////////////////////////////////
//PShape drawWelcomeRiver()
//{
//  PShape r = createShape();
//
//  r.beginShape();
//
//  r.fill(riverColor);
//
//  // r.curveVertex(0, _h * 0.65);
//  r.curveVertex(0, _h * 0.35);
//  for (int i = 0; i < _w*0.75; i+=100)
//  {
//    r.curveVertex(i, _h * 0.35 + _h * 0.5 * sin(radians(i));
//  } // end top row
//
//  r.endShape();
//
//  return r;
//} // end drawWelcomeRiver