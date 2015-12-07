//////////////////////////////////////////
//         Intro screen navigation      //
//////////////////////////////////////////

//////////////////////////////////////////
//         Button Vars                  //
//////////////////////////////////////////
Button nextButton;
Button prevButton;



//////////////////////////////////////////
//         Button Setup                 //
//////////////////////////////////////////
void buttonSetup()
{
  nextButton = new Button(true);
  prevButton = new Button(false);
}



//////////////////////////////////////////
//         Button Class                 //
//////////////////////////////////////////

class Button 
{
  float remaining = 1.0;
  // what type is the button
  boolean next;
  String n = "Next";
  String b = "Back";
  float d = 40; // diameter of buttons
  float timer = 3000;

  boolean runningNow = true;

  Button(boolean tempNext)
  {
    next = tempNext;
  }

  void run()
  {
//    println(runningNow);
    if (runningNow && _masterState > 3) 
    {
      checkOverButton();
    } else {
      //      println("waiting: " + frameCount);
    } 
    if (next)
    {
      drawNextButton();
    } else
    {
      drawPreviousButton();
    }
  }



  void drawNextButton()
  {
    pushMatrix();
    // outline
    strokeWeight(2);
    stroke(0);
    fill(360);
    translate(_w * 0.90, _h * 0.50);
    ellipse(0, 0, d, d);
    noStroke();
    textFont(hintFont);
    fill(0);
    text(n, 0-textWidth(n)/2, 5); 
    popMatrix();
  }

  void drawPreviousButton()
  {
    pushMatrix();
    // outline
    strokeWeight(2);
    stroke(0);
    fill(360);
    translate(_w * 0.10, _h * 0.50);
    ellipse(0, 0, d, d);
    noStroke();
    textFont(hintFont);
    fill(0);
    text(b, 0-textWidth(n)/2, 5); 
    popMatrix();
  }


  void checkOverButton()
  {
    // print("button check during : " + _masterState);
    for (Map.Entry entry : leapObject.entrySet ())
    {
      // the object's entry in the map and an object to store it:
      Integer entryKey = (Integer) entry.getKey();
      LeapObject object = (LeapObject) entry.getValue();
      // check if it is valid
      if (object.isValid)
      {
        if (dist(object.handPosition.x, object.handPosition.y, _w * .9, _h * .5) < d/2)
        {
//          println("nextState, button, going from: " + _masterState);
//          println("leap size: " + leapObject.size());
          nextState();
        } else {
          if (dist(object.handPosition.x, object.handPosition.y, _w * .1, _h * .5) < d/2)
          {
//            println("lastState, button");
            lastState();
          }
        }
      } else 
      {
        // object is not valid, remove it
        leapObject.remove(entryKey);
      } // end if object is valid
    } // end for each entry in the map
  } // end checkOverButton()
} // end class