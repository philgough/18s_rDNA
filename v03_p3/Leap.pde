//////////////////////////////////////////
//       Leap Motion Variables          //
//////////////////////////////////////////


// Leap Motion Controller
import com.leapmotion.leap.Controller;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.FingerList;
import com.leapmotion.leap.Frame;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.processing.LeapMotion;

import java.util.Map;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;

LeapMotion leap;
ConcurrentHashMap<Integer, LeapObject> leapObject;

boolean userPresent = false;
int leapWelcomeTimer = 0;
// boolean isInsideSettlement;

//////////////////////////////////////////
//       Leap Motion Setup              //
//////////////////////////////////////////

void leapMotionSetup()
{
  leap = new LeapMotion(this);
  leapObject = new ConcurrentHashMap<Integer, LeapObject>();
}


//////////////////////////////////////////
//       Leap Motion Draw function      //
//////////////////////////////////////////

void drawLeap()
{
  for (int i = 0; i < hintIndex.length; i++) 
  {
    hintIndex[i] = false;
  }
  for (Map.Entry entry : leapObject.entrySet ())
  {
    // the object's entry in the map and an object to store it:
    Integer entryKey = (Integer) entry.getKey();
    LeapObject object = (LeapObject) entry.getValue();
    // check if it is valid
    if (object.isValid)
    {
      // object is valid, do something

      if (!estuary.insideRiver(object.handPosition))
      {
        // not inside river
        
        hintIndex[2] = true;
        hintIndex[3] = true;
        
        
        // there's no games, but we need the timer for the river and the hint
        if (games.size() == 0)
        {
          if (object.numExtendedFingers == 5)
          {
            if (object.handMovementProbability < object.handMovementProbabilityThreshold)
            {
              //yes
              noStroke();
              fill(190, 75, 100);
              float f = map(millis() - object.lastRecordedTime, 0, object.interval, 0, TWO_PI);
              arc(object.handPosition.x, object.handPosition.y, 30, 30, 0, f, PIE);
            }
          } else 
          {
//            showHint(5);
            currentHint = 5;
          } // check for hint display
        }
        // is it over a settlement?
        for (int i = 0; i < games.size (); i++) 
        {
          Game g = games.get(i);
          if (g.withinBounds(object.handPosition))
          {
            if (object.numExtendedFingers == 4)
            {
              if (object.handMovementProbability < object.handMovementProbabilityThreshold)
              {
                //yes
                noStroke();
                fill(190, 75, 100);
                float f = map(millis() - object.lastRecordedTime, 0, object.interval, 0, TWO_PI);
                arc(object.handPosition.x, object.handPosition.y, 30, 30, 0, f, PIE);
              }
            } else
            {
//              showHint(4);
              currentHint = 4;
            }
          } 

          // not inside the game bounds.
          else {
            if (object.numExtendedFingers == 5)
            {
              if (object.handMovementProbability < object.handMovementProbabilityThreshold)
              {
                //yes
                noStroke();
                fill(190, 75, 100);
                float f = map(millis() - object.lastRecordedTime, 0, object.interval, 0, TWO_PI);
                arc(object.handPosition.x, object.handPosition.y, 30, 30, 0, f, PIE);
              }
            }
          } // end if in object bounds
        } // end for each game
      } else
      {
        hintIndex[0] = true;
        hintIndex[1] = true;
      } // end if not inside river

      // draw the cursor
      stroke(80);
      strokeWeight(1);
      fill(170);
      ellipse(object.handPosition.x, object.handPosition.y, 15, 15);
      object.fingers(object.numExtendedFingers);
    } else 
    {
      // object is not valid, remove it
      leapObject.remove(entryKey);
    } // end if object is valid
  } // end for each entry in the map
} // end drawLeap()




//////////////////////////////////////////
//       Leap Motion Welcome Screen     //
//////////////////////////////////////////
void welcomeLeap()
{
  for (Map.Entry entry : leapObject.entrySet ())
  {
    // the object's entry in the map and an object to store it:
    Integer entryKey = (Integer) entry.getKey();
    LeapObject object = (LeapObject) entry.getValue();
    // check if it is valid
    if (object.isValid)
    {
      // object is valid, draw something
      fill(170);
      stroke(80);
      strokeWeight(1);
      ellipse(object.handPosition.x, object.handPosition.y, 20, 20);
      object.fingers(object.numExtendedFingers);
      object.listenToMe = false;
      if (!userPresent)
      {
        userPresent = true;
        leapWelcomeTimer = millis();
        // println("hello, user");
      }
    } else 
    {
      // object is not valid, remove it
      leapObject.remove(entryKey);
    } // end object is valid
  } // end for each entry in the map
  if (millis() > leapWelcomeTimer + 2000 && userPresent && _masterState == WELCOME_SCREEN)
  {
    println("nextState welcomeLeap()");
    nextState();
    userPresent = false;
  }
} // end welcomeLeap



//////////////////////////////////////////
//       Leap Motion Class              //
//////////////////////////////////////////

class LeapObject
{

  PVector handPosition = new PVector(0, 0);
  int id;
  int numExtendedFingers;
  boolean isValid;
  float handMovementProbability;
  float handMovementProbabilityThreshold = 0.8;

  // 2-second timer
  int interval = 2000;
  int lastRecordedTime = 0;
  int lastState = 9001; 

  boolean listenToMe = true;


  LeapObject(float tempHandPositionX, float tempHandPositionY, int tempID, boolean tempValid, int tempNumExtendedFingers) 
  {
    id = tempID;
    numExtendedFingers = tempNumExtendedFingers;
    handPosition.set(tempHandPositionX, tempHandPositionY);
    isValid = tempValid;
    handMovementProbability = 0;
  }

  // ** How many fingers are held out ** \\
  void fingers(int state) 
  {
    // ** we are only interested if they haven't just changed... ** \\
    if (state == lastState) 
    {
      // ** if the timer isn't still going... ** \\
      if ( lastRecordedTime + interval < millis())
      {
        // do something
        switch(state) 
        {
        default: 
          println(state + " fingers held for timer");
          break;
        case 0 :
          println("no fingers held for timer");
          break;
          // ** 1 finger cleans the waste ** \\
        case 1 : 
          // println("1 finger held for timer");
          // This is done in the pollution class
          break;
          // ** 2 fingers shows a graph ** \\
        case 2 :
          // this is done in the organism class
          break;
          // ** 4 fingers removes a settlement ** \\
        case 4 :
          checkForSettlementRemoval(handPosition);
          break;
          // ** 5 fingers adds a settlement ** \\
        case 5 :
//          if (!estuary.insideRiver(handPosition) && handMovementProbability < handMovementProbabilityThreshold && listenToMe)
          if (!estuary.insideRiver(handPosition) && handMovementProbability < handMovementProbabilityThreshold && listenToMe)
          {
            // println("5 fingers held for timer, adding new settlement"); 
            games.add(new Game(handPosition.x, handPosition.y));
          }
          break;
        } // end switch
        // reset timer
        lastRecordedTime = millis();
      } // end if timer is still going
    }  // end if state is equal to last state
    else {
      lastState = state;
    } // end since state is NOT equal to the last state
  } // end fingers()
} // end class


//////////////////////////////////////////
//       Leap Motion Custom Functions   //
//////////////////////////////////////////

void checkForSettlementRemoval(PVector handPosition)
{
  for (int i = 0; i < games.size (); i++) 
  {
    Game g = games.get(i);
    // println(g.numAliveCells);
    if (handPosition.dist(g.location) < 100) 
    {
      println("4 fingers held for timer, removing a settlement"); 
      games.remove(i);
    } // end death check
  } // end for loop
} // end checkForSettlementRemoval


//////////////////////////////////////////
//       Leap Motion Control stuff      //
//////////////////////////////////////////

void onFrame(final Controller controller)
{
  // get the frame from the controller
  Frame frame = controller.frame();

  // invalidate every object that was there in the last frame, so we only keep the ones we want.
  for (Map.Entry entry : leapObject.entrySet ())
  {
    LeapObject object = (LeapObject) entry.getValue();
    object.isValid = false;
  }

  // check and see if there's no hands this frame
  if (frame.hands().isEmpty()) 
  {
    return;
  }
  // otherwise
  else 
  {
    // for each hand
    for (Hand hand : frame.hands ())
    {
      // count the number of extended fingers
      // FingerList allFingers = frame.fingers();
      // int numFingers = allFingers.count();
      int extendedFingers = 0;
      for (Finger finger : hand.fingers ())
      {
        if (finger.isExtended()) extendedFingers++;
      }



      //println("extendedFingers: " + extendedFingers);
      // get the position of the hand as x & y
      float x = width/2 + lerp(0, width, hand.stabilizedPalmPosition().getX()/300);
      float y = 300 + lerp(height, 0, hand.stabilizedPalmPosition().getY()/200);

      // check if the hand is the list already
      if (leapObject.containsKey(hand.id())) 
      {
        // hand is already in the list
        LeapObject temp = leapObject.get(hand.id());
        // if the hand is valid, set the boolean in the class object
        temp.isValid = hand.isValid();
        temp.handPosition.set(x, y);
        temp.numExtendedFingers = extendedFingers;

        // set the likelihood that the hand is moving
        //// look for the past 100 frames
        //int startFrame = int(hand.frame().id() - 100);
        temp.handMovementProbability = hand.translationProbability(controller.frame(5));
        // println(startFrame + ": " + hand.frame().id());
        // println(hand.translationProbability(controller.frame(10)));
      }
      // otherwise 
      else 
      {
        // add a new hand to the list
        // create temporary object       
        LeapObject temp = new LeapObject(x, y, hand.id(), hand.isValid(), extendedFingers);
        // add it to the list
        leapObject.put(hand.id(), temp);
      } // new hand added to list
    } // end for each hand
  } // end otherwise (i.e. there is a hand in the frame)
}




void onInit(final Controller controller)
{
  println("Initialized");
}

void onConnect(final Controller controller)
{
  println("Connected");
}

void onDisconnect(final Controller controller)
{
  println("Disconnected");
}

void onExit(final Controller controller)
{
  println("Exited");
}