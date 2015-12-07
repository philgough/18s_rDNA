//////////////////////////////////////////
//        Data Variables                //
//////////////////////////////////////////



//////////////////////////////////////////
//        Data Setup                    //
//////////////////////////////////////////
void dataSetup()
{
  // Load the csv files
  Table table0 = loadTable("data/phNegZ.csv", "header");
  Table table1 = loadTable("data/phPosZ.csv", "header");
  Table table2 = loadTable("data/phosNegZ.csv", "header");
  Table table3 = loadTable("data/phosPosZ.csv", "header");

  for (int i = 0; i < organism.size (); i++) {
    println(i);
    // z = reaction, higher is stronger reaction
    // med = environmental concentration point - median of the bell-curve
    // p5th, p95th = 5th and 95th percentile
    TableRow row;
    float median;
    float p5th;
    float p95th;
    float z;


    Organism o = organism.get(i);

    switch (o.type)
    {
    case 2 :

      // freshWater : group 2 (arc towards river)
      row = table0.getRow(i%table0.getRowCount());

      median = row.getFloat("env.cp");
      p5th = row.getFloat("0.05");
      p95th = row.getFloat("0.95");
      z = row.getFloat("z");

      o.graph.p5 = p5th;
      o.graph.med = median;
      o.graph.p95 = p95th;
      o.graph.positive = false;
      o.pollutionReactionTimerRate = z * 10;
      o.z = z;

      //println(p5th);
      //println(o.graph.p5);
      break;


    case 0 :

      // saltWater: group 1 (arc towards ocean)
      row = table1.getRow(i%table1.getRowCount());

      median = row.getFloat("env.cp");
      p5th = row.getFloat("0.05");
      p95th = row.getFloat("0.95");
      z = row.getFloat("z");

      o.graph.p5 = p5th;
      o.graph.med = median;
      o.graph.p95 = p95th;
      o.graph.positive = true;
      o.pollutionReactionTimerRate = z * 10;
      o.z = z;

      break;


      // <3's clean water: group 2 (arc towards height)
    case 1 :
      row = table2.getRow(i%table2.getRowCount());

      median = row.getFloat("env.cp");
      p5th = row.getFloat("0.05");
      p95th = row.getFloat("0.95");
      z = row.getFloat("z");
      o.graph.p5 = p5th;
      o.graph.med = median;
      o.graph.p95 = p95th;
      o.graph.positive = false;
      o.pollutionReactionTimerRate = z * 10;
      o.z = z;

      break;



      // <3's dirty water: group 3 (arc towards 0)
    case 3 :
      row = table3.getRow(i%table3.getRowCount());

      median = row.getFloat("env.cp");
      p5th = row.getFloat("0.05");
      p95th = row.getFloat("0.95");
      z = row.getFloat("z");


      o.graph.p5 = p5th;
      o.graph.med = median;
      o.graph.p95 = p95th;  
      o.graph.positive = true;
      o.pollutionReactionTimerRate = z * 10;
      o.colorScale = 0;
      o.z = z;

      break;
    }

    o.finalOrganismSetup();
  } // end for loop

    println("ENDED dataSetup");
} // end setup





//////////////////////////////////////////
//        Data Draw                     //
//////////////////////////////////////////










//////////////////////////////////////////
//        Data Class                    //
//////////////////////////////////////////