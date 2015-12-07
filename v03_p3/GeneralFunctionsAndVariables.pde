///////////////////////////////////////////
//    General Collection of Variables   //
//////////////////////////////////////////


// ** a few different states for the application ** \\
final int WELCOME_SCREEN = 0;
final int INTERACTIVE_PLAY_STATE = 1;
final int FADE_IN = 2;
final int FADE_OUT = 3;
final int INTRO_SCREEN_1 = 4;
final int INTRO_SCREEN_2 = 5;
final int INTRO_SCREEN_3 = 6;
final int INTRO_SCREEN_0 = 7;

//int _masterState = INTERACTIVE_PLAY_STATE;
 int _masterState = WELCOME_SCREEN;
// int _masterState = INTRO_SCREEN_1;
int _lastState = _masterState;
int _nextState = _lastState;

PImage welcomeSlide;

float _fadeAlpha = 0;

int _introTimer = 0;

color _backgroundColour; 

// ** images of hands ** \\
PImage hand5Big;
PImage hand5;
PImage hand4;
PImage hand3;
PImage hand2;
PImage hand1;

// ** text ** \\
PFont titleFont;
PFont bodyFont;
PFont hintFont;

// welcome screen text
String welcomeText1 = "All cell-based life on earth shares one gene:";
String welcomeTitle = "18s rDNA";
String welcomeText2 = "hold out your hand";

// intro screen 1 text and vars
String introScreen1a = "These organisms, which live in estuaries, thrive in salt water";
String introScreen1b = "these thrive in fresh water";
float screen1Shift = 0;

// Intro screen 2 text and vars
String introScreen2a = "These organisms, which live in estuaries, thrive in dirty water";
String introScreen2b = "these thrive in clean water";

// Intro screen 3 text and vars
String introScreen3a = "Human activity introduces phosphorus to estuaries";
String introScreen3b = "it comes from farming and city wastewater"+"\n"+"and is an indication of pollution";

// Intro screen 0 text and vars
String introScreen0a = "Scientists can examine the gene 18s rDNA";
String introScreen0b = "to distinguish between these four different types of organisms";




void startIntroScreen3()
{
  if (games.size() < 1)
  {
    games.add(new Game(200, 120));
    println("added a new game");
  }
  // println("screen 3 started");
} // end startIntroScreen3


// hints
String welcomeHint = "hold out your hand to continue";

String hint1 = "Extend one finger and move your hand to clean pollution";
String hint2 = "Extend two fingers to inspect an organism";
String hint4 = "Extend four fingers to remove a settlement";
String hint5 = "Extend five fingers to place a human settlement"; 

String hints[] = {hint1, hint2, hint4, hint5};
boolean hintIndex[] = {false, false, false, false};
void configSetup() 
{
  
  _backgroundColour = color(99, 3, 88);
   
  welcomeSlide = loadImage("slides/welcomeSlide.png");

  // hand5Big = loadImage("resources/hand5Big.png");
  hand5 = loadImage("resources/hand5.png");
  hand4 = loadImage("resources/hand4.png");
  hand3 = loadImage("resources/hand3.png");
  hand2 = loadImage("resources/hand2.png");
  hand1 = loadImage("resources/hand1.png");

  titleFont = createFont("HelveticaNeue-LightItalic", 160);
  bodyFont = createFont("HelveticaNeue-UltraLight", 50);
  hintFont = createFont("HelveticaNeue-UltraLightItalic", 12);
}



//////////////////////////////////////////
//    General Collection of Functions   //
//////////////////////////////////////////


boolean insideShape(PShape s, PVector p) 
{
  int n = s.getVertexCount();
  boolean c = false;
  int j = n-1;
  for (int i = 0; i < n; j = i++) 
  {
    PVector a = s.getVertex(i);
    PVector b = s.getVertex(j);
    if (((a.y > p.y) != (b.y > p.y)) && (p.x < (b.x - a.x) * (p.y - a.y) / (b.y - a.y) + a.x)) 
    {
      c = !c;
    } // end if statement
  }  // end for loop
  return c;
}  // end boolean insideShape