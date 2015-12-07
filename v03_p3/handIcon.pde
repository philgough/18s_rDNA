//////////////////////////////////////////
//         Bottom left hand icon        //
//////////////////////////////////////////


void drawHandIcon()
{
  int numHands = 0;
  int imgSize = 51;
  for (Map.Entry entry : leapObject.entrySet ())
  {
    LeapObject object = (LeapObject) entry.getValue();
    numHands++;
    if (object.isValid)
    {
      // object is valid, draw something
      switch(object.numExtendedFingers)
      {
      default:
        break;

      case 1:
        image(hand1, numHands * imgSize, _h  * .92 - imgSize, imgSize, imgSize);
        break;

      case 2:
        image(hand2, numHands * imgSize, _h  * .92 - imgSize, imgSize, imgSize);
        break;

      case 3:
        image(hand3, numHands * imgSize, _h  * .92 - imgSize, imgSize, imgSize);
        break;

      case 4:
        image(hand4, numHands * imgSize, _h  * .92 - imgSize, imgSize, imgSize);
        break;

      case 5:
        image(hand5, numHands * imgSize, _h  * .92 - imgSize, imgSize, imgSize);
        break;
      } // end switch
    } // end if valid
  } // end for map entry
} // end handDrawIcon




//////////////////////////////////////////
//         Hint text bottom left        //
//////////////////////////////////////////

int currentHint = 9001;
//void showHint(String hint)
//{
//  println(hint + ": " + currentHint);
//  if (currentHint > 10) {
//    textFont(hintFont);
//    fill(80);
//    text(hint, 5, _h * 0.99);
//  }
//}



void drawHint() 
{
  

  
  for (int i = 0; i < hints.length; i++)
  {
    fill(270);
    if (hintIndex[i]) 
    {
      fill(50);
    }
    text(hints[i], 5, _h * 0.99 - 14 * i);  
  }
}