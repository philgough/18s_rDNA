//public void init() {
// /// to make a frame not displayable, you can 
// // use frame.removeNotify() 
// frame.removeNotify(); 

// frame.setUndecorated(true); 

// // addNotify, here i am not sure if you have  
// // to add notify again.   
// frame.addNotify(); 
// //super.init();
//} 


void setup()   
{
  // General Config
  //size(1920, 1280, P2D);
  fullScreen(P2D);
  pixelDensity(2);
  hint(DISABLE_DEPTH_TEST); // avoids z-fighting


  colorMode(HSB, 360, 100, 100, 100);

  noCursor();
  rectMode(CENTER);
  imageMode(CENTER);
  smooth();

  // hint(ENABLE_ACCURATE_2D); // strokes are drawn correctly

  //  setup different things that need setting up
  configSetup();
  riverSetup();
  leapMotionSetup();
  gameOfLifeSetup();
  organismSetup();
  pollutionSetup();
  dataSetup();
  graphSetup();
  buttonSetup();
  dashboardSetup();
  println("setup complete");
 
  // set frame position
  //frame.setLocation(1920, 150);
} // end setup


void draw() 
{
  drawSwitch(_masterState);
  drawHandIcon();
  drawDashboard();
}




void drawSwitch(int s) {
  switch(s)
  {
  case WELCOME_SCREEN :

    drawWelcome();
    break;


  case INTERACTIVE_PLAY_STATE :

    drawMain();
    break;


  case INTRO_SCREEN_1 :

    drawIntroScreen_1();
    break;

  case INTRO_SCREEN_2 :
    drawIntroScreen_2();
    break;

  case INTRO_SCREEN_3 :
    drawIntroScreen_3();
    break;


  case INTRO_SCREEN_0 :
    drawIntroScreen_0();
    break;

  case FADE_OUT :
    fadeOut();
    break;

  case FADE_IN :
    fadeIn();
    break;



  default :
    _masterState = WELCOME_SCREEN;
  }
} // end draw





void drawWelcome()
{
  background(360);
  textFont(bodyFont);
  fill(80);
  text(welcomeText1, _w/2 - textWidth(welcomeText1)/2, _h * 0.1);

  textFont(titleFont);
  fill(80);
  text(welcomeTitle, _w/2 - textWidth(welcomeTitle)/2, _h/3);

  // image(hand5Big, _w/2, _h * 0.6, 400, 400);

  textFont(bodyFont);
  text(welcomeText2, _w/2 - textWidth(welcomeText2)/2, _h * 0.85);

  welcomeLeap();
  currentHint = 8008;
} // end drawWelcome



void drawMain() 
{
  //background(43, 17, 90);
  background(300);
  runGameOfLife();  
  shape(estuary.river, 0, 0);
  drawPollution();
  drawOrganisms();
  drawGraphs();
  drawLeap();
  drawHint();
  currentHint = 9001;
} // end drawMain



void drawIntroScreen_0() 
{
  nextButton.runningNow = false;
  prevButton.runningNow = false;

  background(360);
  shape(estuary.river);
  textFont(bodyFont);
  fill(80); 
  text(introScreen0a, _w/2 - textWidth(introScreen0a)/2, _h * 0.25);
  text(introScreen0b, _w/2 - textWidth(introScreen0b)/2, _h * 0.75);


 organismsForWelcomeScreen(3, _w * 0.44, _h * .5, 0);
 organismsForWelcomeScreen(1, _w * 0.48, _h * .5, 0);
 organismsForWelcomeScreen(2, _w * 0.52, _h * .5, 0);
 organismsForWelcomeScreen(0, _w * 0.56, _h * .5, 0);


  if (millis() < (_introTimer + 3000))
  {
    leapWelcomeTimer = millis();
    // println("win");
  } else 
  {
    if (_masterState == INTRO_SCREEN_0)
    {
      nextButton.runningNow = true;
      prevButton.runningNow = true;
    }

    welcomeLeap();
    nextButton.run();
    // prevButton.run();
  } // end timer check
} // end drawIntroScreen_0



void drawIntroScreen_1() 
{
  //    println(nextButton.runningNow + " " + prevButton.runningNow);

  nextButton.runningNow = false;
  prevButton.runningNow = false;
  background(360);
  shape(estuary.river);
  textFont(bodyFont);
  fill(80); 
  text(introScreen1a, _w/2 - textWidth(introScreen1a)/2, _h * 0.25);
  text(introScreen1b, _w/2 - textWidth(introScreen1b)/2, _h * 0.75);


  organismsForWelcomeScreen(2, _w/2 - screen1Shift, _h * 0.52, screen1Shift);
  organismsForWelcomeScreen(0, _w/2 + screen1Shift, _h * 0.48, screen1Shift);


  if (millis() > (_introTimer + 3000))
  {
    if (screen1Shift < 699) 
    {
      screen1Shift += (700 - screen1Shift) * 0.02;
      leapWelcomeTimer = millis();
    } else 
    {
      welcomeLeap();

      if (_masterState == INTRO_SCREEN_1)
      {
        nextButton.runningNow = true;
        prevButton.runningNow = true;
      }
      nextButton.run();
      prevButton.run();
    }
  }
} // end drawIntroScreen_1


void drawIntroScreen_2()
{
  //    println(nextButton.runningNow + " " + prevButton.runningNow);
  nextButton.runningNow = false;
  prevButton.runningNow = false;

  background(360);
  shape(estuary.river);
  textFont(bodyFont);
  fill(80); 
  text(introScreen2a, _w/2 - textWidth(introScreen2a)/2, _h * 0.25);
  text(introScreen2b, _w/2 - textWidth(introScreen2b)/2, _h * 0.75);


  organismsForWelcomeScreen(1, _w/2, _h * 0.55, 360);
  organismsForWelcomeScreen(3, _w/2, _h * 0.45, 0);


  if (millis() < (_introTimer + 3000))
  {
    leapWelcomeTimer = millis();
    // println("win");
  } else 
  {
    welcomeLeap();
    if (_masterState == INTRO_SCREEN_2)
    {
      nextButton.runningNow = true;
      prevButton.runningNow = true;
    }
    nextButton.run();
    prevButton.run();
  } // end timer check
} // end draw introScreen2



void drawIntroScreen_3()
{
  //    println(nextButton.runningNow + " " + prevButton.runningNow);
  nextButton.runningNow = false;
  prevButton.runningNow = false;

  background(360);
  runGameOfLife();  
  shape(estuary.river, 0, 0);
  drawLeap();
  drawPollution();
  textFont(bodyFont);
  fill(80); 
  text(introScreen3a, _w/2 - textWidth(introScreen3a)/2, _h * 0.25);
  text(introScreen3b, _w/2 - textWidth(introScreen3b)/2, _h * 0.75);




  if (millis() < (_introTimer + 3000))
  {
    leapWelcomeTimer = millis();
    // println("win");
  } else 
  {
    welcomeLeap();
    if (_masterState == INTRO_SCREEN_3)
    {
      nextButton.runningNow = true;
      prevButton.runningNow = true;
    }
    nextButton.run();
    prevButton.run();
  } // end timer check
}


void fadeOut()
{
  nextButton.runningNow = false;
  prevButton.runningNow = false;
//  println(nextButton.runningNow + " " + prevButton.runningNow);
  drawSwitch(_lastState);
  //  println("fade out : " + _fadeAlpha);
  if (_fadeAlpha < 100) 
  {
    _fadeAlpha += (101 - _fadeAlpha) * 0.08;
  } else 
  {
    nextState();
//    println("nextState, fadeout frame: " + frameCount);
  } // end alpha check
  noStroke();
  fill(0, 0, 100, _fadeAlpha);
  rect(_w/2, _h/2, _w, _h);
} // end fadeOut

void fadeIn()
{
  nextButton.runningNow = false;
  prevButton.runningNow = false;
  drawSwitch(_nextState);

  if (_fadeAlpha > 1) 
  {
//    println("fade in alpha: " + _fadeAlpha);
    _fadeAlpha += (0 - _fadeAlpha) * 0.08;
    _introTimer = millis();
  } else 
  {
    if (_lastState == INTRO_SCREEN_2)
    {
      // println("starting screen 3");
      startIntroScreen3();
    } // end screen 3 check

//    println("nextState, fadeIn frame: " + frameCount);
    nextState();
  } // end alpha check
  noStroke();
  fill(0, 0, 100, _fadeAlpha);
  rect(_w/2, _h/2, _w, _h);
} // end fadeIn


void nextState()
{
  switch(_masterState)
  {
  case WELCOME_SCREEN :
    _lastState = WELCOME_SCREEN;
    _nextState = INTRO_SCREEN_0;
    _masterState = FADE_OUT;
    break;

  case FADE_OUT : 
    _masterState = FADE_IN;
    break;

  case FADE_IN :
    _masterState = _nextState;
    break;

  case INTRO_SCREEN_1 :
    _lastState = INTRO_SCREEN_1;
    _nextState = INTRO_SCREEN_2;
    _masterState = FADE_OUT;
    _fadeAlpha = 0;
//    println("introscreen1 going to fade out: " + _masterState);
    break;

  case INTRO_SCREEN_2 :
    _lastState = INTRO_SCREEN_2;
    _nextState = INTRO_SCREEN_3;
    _masterState = FADE_OUT;
    _fadeAlpha = 0;
//    println("introscreen1 going to fade out: " + _masterState);
    break;


  case INTRO_SCREEN_3 :
    _lastState = INTRO_SCREEN_3;
    _nextState = INTERACTIVE_PLAY_STATE;
    _masterState = FADE_OUT;
    _fadeAlpha = 0;
//    println("introscreen1 going to fade out: " + _masterState);
    break;

  case INTRO_SCREEN_0 :
    screen1Shift = 0;
    _lastState = INTRO_SCREEN_0;
    _nextState = INTRO_SCREEN_1;
    _masterState = FADE_OUT;
    break;
  default:
//    println("nextState confusion, recieved: " + _masterState);
//    println("shutting buttons off");
    nextButton.runningNow = false;
    prevButton.runningNow = false;

    break;
  } // end switch
} // end nextState


void lastState()
{
  switch(_masterState)
  {
  case WELCOME_SCREEN :
    break;

  case FADE_OUT : 
    _masterState = FADE_IN;
    break;

  case FADE_IN :
    _masterState = _nextState;
    break;

  case INTRO_SCREEN_1 :
    _lastState = INTRO_SCREEN_1;
    _nextState = INTRO_SCREEN_0;
    _masterState = FADE_OUT;
    break;

  case INTRO_SCREEN_2 :
    _lastState = INTRO_SCREEN_2;
    _nextState = INTRO_SCREEN_1;
    _masterState = FADE_OUT;
    // unbreak screen 1
    screen1Shift = 0;
    break;

  case INTRO_SCREEN_3 :
    _lastState = INTRO_SCREEN_3;
    _nextState = INTRO_SCREEN_2;
    _masterState = FADE_OUT;
    break;

  case INTRO_SCREEN_0 :
    break;

  default:
//    println("lastState confusion, recieved: " + _masterState);
//    println("shutting buttons off");
    nextButton.runningNow = false;
    prevButton.runningNow = false;


    break;
  } // end switch
}

void mouseClicked()
{
  nextState();
//  println("nextState, mouse");
  // games.add(new Game(mouseX, mouseY));
}