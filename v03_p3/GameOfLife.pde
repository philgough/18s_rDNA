//////////////////////////////////////////
//       Game of Life Variables         //
//////////////////////////////////////////

ArrayList <Game> games;
PShape building;

float gameCellSize = 10;

//////////////////////////////////////////
//       Game of Life Setup             //
//////////////////////////////////////////

void gameOfLifeSetup ()
{
  games = new ArrayList<Game>();

  building = createShape();

  building.beginShape();
  //building.noFill();
  building.fill(46, 3, 93);
  // building.stroke(0, 0, 88);
  building.stroke(104, 3, 88);
  building.strokeWeight(2);
  building.vertex(0, 0);
  building.vertex(0, gameCellSize);
  building.vertex(gameCellSize, gameCellSize);
  building.vertex(gameCellSize, 0);
  building.endShape(CLOSE);

  println("game of life setup done");
}



//////////////////////////////////////////
//       Game of Life Draw              //
//////////////////////////////////////////

void runGameOfLife ()
{

  // println(games.size());
  // ** run game of life ** \\
  for (int i = 0; i < games.size (); i++) 
  {
    Game g = games.get(i);
    // println(g.numAliveCells);
    g.play();
    if (g.numAliveCells == 0) 
    {
      games.remove(i);
    } // end death check
  } // end for loop


  // ** we check to see if we add a new settlement in the drawLeap, since we iterate over the list there ** \\
} // end runGameOfLife



//////////////////////////////////////////
//       Game of Life Class             //
//////////////////////////////////////////


class Game 
{
  // dimensions for each game, and location for it to be set
  // note: rectMode will be set to CENTER
  PVector dimensions = new PVector(160, 90);
  PVector location = new PVector(0, 0);

  // GoL interval/timer - turn up interval if it lags too much
  int gameInterval = 200;
  int lastRecordedGameTime = 0;

  // waste interval/timer
  int wasteInterval = 2000;
  int lastRecordedWasteTime;
  // display settings
  color border = color(0, 0, 88);
  // color alive = color(175);
  color alive = color(46, 3, 93);
  color dead = color(104, 3, 88);

  // cells
  float cellSize = gameCellSize;
  float probabilityOfAliveAtStart = .50;
  int numAliveCells = 0;

  // cell arrays
  int[][] cells;
  int[][] cellsBuffer;


  // sewer entry point on the river
  PVector closestRiverVertex = new PVector(0, 0);
  PVector sewerPoint = new PVector(0, 0);


  Game(float lx, float ly) 
  {
    // set location of **CENTER** of game
    location.set(lx - dimensions.x/2, ly - dimensions.y/2);
    // instantiate arrays
    cells = new int[ceil(dimensions.x/cellSize)][ceil(dimensions.y/cellSize)];
    cellsBuffer = new int[ceil(dimensions.x/cellSize)][ceil(dimensions.y/cellSize)];


    // ** Initialization of cells ** \\
    // temporary PVector to check and see if it's somewhere it's not allowed to be
    PVector tempIndividualCellLocation = new PVector(0, 0);
    for (int x=0; x<dimensions.x/cellSize; x++) 
    {
      for (int y=0; y<dimensions.y/cellSize; y++) 
      {
        float state = randomGaussian();
        if (abs(state) > probabilityOfAliveAtStart) 
        { 
          state = 0;
        } else 
        {
          state = 1;
        }

        // ** test to see whether cells are active ** \\ 

        tempIndividualCellLocation.set(location.x + x*cellSize, location.y + y*cellSize);
        // if estuary.insideRiver or off screen - don't need to test for tempIndividualLocation.x > width, since we can't get there anyway
        if (estuary.insideRiver(tempIndividualCellLocation) || (tempIndividualCellLocation.y < 0 || tempIndividualCellLocation.y > height) || (tempIndividualCellLocation.x < 0)) // change this test!! 
        {
          // don't display, not in a valid position
          state = 9001;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    } // end assigning cells dead or alive

      // ** check position above/below river, and set a sewer point based on that ** \\
    if (location.y > height/2)
    {
      // below river
      sewerPoint.set(location.x + dimensions.x/2, location.y);
    } else 
    {
      // above river
      sewerPoint.set(location.x + dimensions.x/2, location.y + dimensions.y);
    }

    float d = 9001;
    for (int i = 0; i < estuary.river.getVertexCount (); i++) 
    {
      // figure out which is the closest
      PVector v = estuary.river.getVertex(i);
      if (sewerPoint.dist(v) < d)
      {
        d = sewerPoint.dist(v);
        closestRiverVertex.set(v);
      }
    } // end check for closest vertex

    //int i = 0;
    if (sewerPoint.y < height/2)
    {
      // above river
      while (estuary.insideRiver (sewerPoint)) 
      {
        sewerPoint.y-=10;
      } // end while
    } 
    // below the river
    else 
    {
      // above river
      while (estuary.insideRiver (sewerPoint)) 
      {
        sewerPoint.y += 10;
      }
    }

    lastRecordedWasteTime = millis();
  } // end constructor

  void play() 
  {
    // Iterate if timer ticks
    if (millis() - lastRecordedGameTime > gameInterval) 
    {
      update();
      lastRecordedGameTime = millis();
    }

    if (millis() - lastRecordedWasteTime > wasteInterval)
    {

      addNewWaste();
      lastRecordedWasteTime = millis();
    }

    render();
  }


  void update() 
  {
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    // for (int x=0; x<dimensions.x/cellSize; x++) 
    // {
    //   for (int y=0; y<dimensions.y/cellSize; y++) 
    //   {
    //     cellsBuffer[x][y] = cells[x][y];
    //   }
    // }

    arrayCopy(cells, cellsBuffer); // This is faster, but produces an error, but it has an interesting effect.

    // Visit each cell:
    for (int x=0; x<dimensions.x/cellSize; x++) 
    {
      for (int y=0; y<dimensions.y/cellSize; y++) 
      {
        if (cells[x][y] != 9001) 
        {
          // And visit all the neighbours of each cell
          int neighbours = 0; // We'll count the neighbours
          for (int xx=x-1; xx<=x+1; xx++) 
          {
            for (int yy=y-1; yy<=y+1; yy++) 
            {  
              if (((xx>=0)&&(xx<dimensions.x/cellSize))&&((yy>=0)&&(yy<dimensions.y/cellSize)))
              { // Make sure you are not out of bounds
                if (!((xx==x)&&(yy==y))) 
                { // Make sure to to check against self
                  if (cellsBuffer[xx][yy]==1) 
                  {
                    neighbours ++; // Check alive neighbours and count them
                  }
                } // End of if
              } // End of if
            } // End of yy loop
          } //End of xx loop
          // We've checked the neigbours: apply rules!
          if (cellsBuffer[x][y]==1) 
          { // The cell is alive: kill it if necessary
            if (neighbours < 2 || neighbours > 3) 
            {
              cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
            }
          } else { // The cell is dead: make it live if necessary      
            if (neighbours <= 3 ) // this line was changed from neighbours == 3
            {
              cells[x][y] = 1; // Only if it has 3 neighbours
            }
          } // End of if
        } // End of if (<9001) by Phil
      } // End of y loop
    } // End of x loop
  }

  void render()
  { 
    // noStroke();
    
    
    // Draw grid
    numAliveCells = 0;
    strokeWeight(1);
    stroke(dead);
    fill(0, 0, 100);
    rect(location.x + dimensions.x/2, location.y + dimensions.y/2, dimensions.x, dimensions.y);

    for (int x=0; x<dimensions.x/cellSize; x++) 
    {
      for (int y=0; y<dimensions.y/cellSize; y++) 
      {
        if (cells[x][y] != 9001) 
        {


          if (cells[x][y]==1) 
          {
            numAliveCells++;
            fill(alive); // If alive
            shape(building, location.x + x*cellSize, location.y + y*cellSize, cellSize, cellSize);
            //          } else 
            //          {
            //            fill(dead); // If dead
          }

          //rect (location.x + x*cellSize, location.y + y*cellSize, cellSize, cellSize);
        }
      }
      // println(numAliveCells);
    } // end draw grid
  }

  void drawSewer()
  {
    // draw sewer
    stroke(0, 20, 20);
    strokeWeight(3);
    line(sewerPoint.x, sewerPoint.y, closestRiverVertex.x, closestRiverVertex.y);
    fill(20, 40, 60);
    ellipse(sewerPoint.x, sewerPoint.y, 20, 20);
    ellipse(closestRiverVertex.x, closestRiverVertex.y, 10, 10);
  }

  void addNewWaste()
  {
    pollution.add(new Pollution(sewerPoint, closestRiverVertex, numAliveCells));
  }


  boolean withinBounds(PVector l) 
  {
    boolean b = false;    
    if (l.x > location.x && l.x < location.x + dimensions.x)
    {
      if (l.y > location.y && l.y < location.y + dimensions.y)
      {
        b = true;
      } // end if y
    } // end if x
    return b;
  } // end withinBounds
} // end game class