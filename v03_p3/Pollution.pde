//////////////////////////////////////////
//         Pollution Variables          //
//////////////////////////////////////////

ArrayList <Pollution> pollution;
color wasteColour;


//////////////////////////////////////////
//         Pollution Setup              //
//////////////////////////////////////////

void pollutionSetup()
{
  pollution = new ArrayList <Pollution>();

  println("pollution setup done");
  wasteColour = color(20, 40, 60, 60);
}


//////////////////////////////////////////
//         Pollution Draw               //
//////////////////////////////////////////

void drawPollution()
{
  for (int i = 0; i < games.size (); i++) 
  {
    Game g = games.get(i);
    // println(g.numAliveCells);
    g.drawSewer();
  } // end for loop

  for (int i = 0; i < pollution.size (); i++)
  {
    Pollution p = pollution.get(i);
    p.run();
    if (p.timeToDie)
    {
      pollution.remove(i);
    }
  }
} // end drawPollution


//////////////////////////////////////////
//         Pollution Class              //
//////////////////////////////////////////

class Pollution 
{

  PVector location = new PVector(0, 0);

  PVector destination = new PVector(0, 0);

  int state = 0;
  float size;

  FloatList area = new FloatList();

  PShape wasteShape;

  float numVertices;

  float xSpeed = 1.5;

  boolean timeToDie = false;

  float finalYDestination;

  Pollution(PVector tempLocation, PVector tempDestination, float tempSize)
  {
    location.set(tempLocation);
    destination.set(tempDestination);


    size = tempSize;


    numVertices = random(5, 9);
    wasteShape = createShape();

    wasteShape.beginShape();
    wasteShape.fill(wasteColour);
    wasteShape.stroke(0);
    wasteShape.strokeWeight(1);
    for (int i = 0; i < numVertices; i++)
    {
      float x = location.x + (5 * sin(radians((360 * i)/numVertices)));
      float y = location.y + (5 * cos(radians((360 * i)/numVertices)));
      wasteShape.vertex(x, y);
      area.append(5);
    } // end for
    wasteShape.endShape(CLOSE);

    finalYDestination = random(_h);
  }


  void run()
  {
    update();
    render();
  }

  void update()
  {
    float sumOfAreas = 0;

    switch (state)
    {
      // move from spawn point to the river
    case 0 :
      for (int i = 0; i < numVertices; i++)
      {
        float x = location.x + (area.get(i) * sin(radians((360 * i)/numVertices)));
        float y = location.y + (area.get(i) * cos(radians((360 * i)/numVertices)));

        wasteShape.setVertex(i, x, y);
      } // end for
      if (location.dist(destination) > 1)
      {
        // location.x++;
        location.x += (destination.x - location.x) * 0.1;
        location.y += (destination.y - location.y) * 0.1;
      } // end if
      else 
      {
        state++;
      }
      break; // end case 0



      // move along the river      
    case 1 :
      location.x += xSpeed;
      for (int i = 0; i < numVertices; i++)
      {
        float x = location.x + (area.get(i) * sin(radians((360 * i)/numVertices)));
        float y = location.y + (area.get(i) * cos(radians((360 * i)/numVertices)));
        sumOfAreas += area.get(i);
        if (estuary.insideRiver(x, y))
        {
          wasteShape.setVertex(i, x, y);
          if (area.get(i)/1500 < size) // update this? and below
          {
            area.add(i, 1/numVertices);
          } else
          {
            area.sub(i, 1/numVertices);
          }
        } else 
        {
          location.y += (_h/2 - y) * 0.06;
        } // end if
      } // end for
      if (location.x > _w*.8)
      {
        state++;
      }
      if (sumOfAreas < 1)
      {
        // println("die");
        timeToDie = true;
      }

      // check to see if hand is over the river, with one finger out to clean it
      for (Map.Entry entry : leapObject.entrySet ())
      {
        // the object's entry in the map and an object to store it:
        // Integer entryKey = (Integer) entry.getKey();
        LeapObject object = (LeapObject) entry.getValue();
        // check if it is valid
        if (object.isValid)
        {
          if (insideWasteShape(object.handPosition))
          {
            currentHint = 1;
            // println(object.handMovementProbability);
            // object is valid, draw something
            if (object.numExtendedFingers == 1  && object.handMovementProbability > 0.7 && size > 0)
            {
              size -= 20;
              // println("one finger extended");
            } // end if one finger etc
          } // end if inside shape
        } // end if object is valid
      } // end for each leap object
      break; // end case 1


      // it's in the ocean now...
    case 2:
      location.x += xSpeed;

      location.y += (finalYDestination - location.y) * 0.02;

      for (int i = 0; i < numVertices; i++)
      {
        float x = location.x + (area.get(i) * sin(radians((360 * i)/numVertices)));
        float y = location.y + (area.get(i) * cos(radians((360 * i)/numVertices)));
        sumOfAreas += area.get(i);
        // don't bother updating y values any more

        wasteShape.setVertex(i, x, y);

        if (area.get(i)/1500 < size) // update this? 
        {
          area.add(i, 1/numVertices);
        } else
        {
          area.sub(i, 1/numVertices);
        }
      } // end for
      if (sumOfAreas < 1)
      {
        timeToDie = true;
      }

      // check to see if hand is over the river, with one finger out to clean it
      for (Map.Entry entry : leapObject.entrySet ())
      {
        // the object's entry in the map and an object to store it:
        // Integer entryKey = (Integer) entry.getKey();
        LeapObject object = (LeapObject) entry.getValue();
        // check if it is valid
        if (object.isValid)
        {
          // println(object.handMovementProbability);
          // object is valid, draw something
          if (object.numExtendedFingers == 1 && insideWasteShape(object.handPosition) && object.handMovementProbability > 0.7 && size > 0)
          {
            // println("hello, world");
            size -= 20;
            // println("one finger extended");
          } // end if one finger etc
        } // end if object is valid
      } // end for each leap object



      if (location.x > _w+area.max())
      {
        state++;
      }
      break; // end case 2

      // if we end up at state 3, or anything else... KILL IT!!
    default :
      timeToDie = true;
      break;
    } // end switch
  } // end update


  void render()
  {
    shape(wasteShape);
  }

  boolean insideWasteShape(PVector p) 
  {

    int n = wasteShape.getVertexCount();
    boolean c = false;
    int j = n-1;
    for (int i = 0; i < n; j = i++) 
    {
      PVector a = wasteShape.getVertex(i);
      PVector b = wasteShape.getVertex(j);
      if (((a.y > p.y) != (b.y > p.y)) && (p.x < (b.x - a.x) * (p.y - a.y) / (b.y - a.y) + a.x)) 
      {
        c = !c;
      } // end if statement
    }  // end for loop
    return c;
  }  // end boolean insideRiver
}