//////////////////////////////////////////
//         Data Dashboard               //
//////////////////////////////////////////




DashboardButton[] dButtons;


// size of the dasboard buttons
int dButtonSize = 100;

// font for dashboard buttons
PFont dButtonFont;

void dashboardSetup()
{
  // the dashboard buttons
  dButtons = new DashboardButton[3];
  
  // add buttons to dashboard
  dButtons[0] = new DashboardButton(new PVector(dButtonSize/2, _h + dButtonSize/2), loadImage("resources/hand1.png"), "reduce human activity");  
  dButtons[1] = new DashboardButton(new PVector(dButtonSize/2 + dButtonSize, _h + dButtonSize/2), loadImage("resources/hand2.png"), "increase human activity");  
  dButtons[2] = new DashboardButton(new PVector(_w - dButtonSize/2, _h + dButtonSize/2), loadImage("resources/hand3.png"), "home screen");
  
  // button text font
  dButtonFont = createFont("HelveticaNeue-UltraLight", 12);
}

void drawDashboard()
{
  fill(0);
  noStroke();
  // add framerate text while developing
  textFont(hintFont);
  text(frameRate, 10, 10);
  rect(_w/2, height - (height - _h)/2, _w, height - _h);
  
  
  dashboardButtons();
  
}


void dashboardButtons()
{
  // ** 3 buttons - more people, less people, and info screen ** \\
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < dButtons.length; i++)
  {
    // outline of box
    noFill();
    rect(dButtons[i].location.x, dButtons[i].location.y, dButtonSize, dButtonSize);
    // icon
    image(dButtons[i].icon, dButtons[i].location.x, dButtons[i].location.y - dButtonSize/4.7, dButtonSize/3, dButtonSize/3);
    // add some text
    fill(255);
    textAlign(CENTER);
    text(dButtons[i].text, dButtons[i].location.x, dButtons[i].location.y + 30, 80, 40);
    textAlign(LEFT);
  }
}



class DashboardButton
{
  PVector location = new PVector(0, 0);
  PImage icon = new PImage();
  String text;
  DashboardButton(PVector tempLocation, PImage tempIcon, String tempText)
  {
    location.set(tempLocation);
    icon = tempIcon;
    text = tempText;
  }
  
}