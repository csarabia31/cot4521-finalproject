//CAMILO SARABIA FINAL PROJECT
import java.util.*;
import java.util.Collections;


ArrayList<Point>    points     = new ArrayList<Point>();
ArrayList<Point>    points2     = new ArrayList<Point>();
ArrayList<Edge>     edges      = new ArrayList<Edge>();
ArrayList<Polygon>    polygons     = new ArrayList<Polygon>();
ArrayList<Polygon>    polygonShapes     = new ArrayList<Polygon>();
ArrayList<Polygon>    unionPolygon    = new ArrayList<Polygon>();
ArrayList<Polygon>    unionPolygon2    = new ArrayList<Polygon>();

//ARRAYLIST TO HOLD POLYGONS INTERSECTION
ArrayList<Polygon>    polygonsIntersection     = new ArrayList<Polygon>();
//ARRAYLIST TO HOLD SET DIFFERENCE
ArrayList<Polygon>    finalPolygonArray    = new ArrayList<Polygon>();
//ARRAYLIST TO HOLD SYMMETRIC DIIFFERENCE
ArrayList<Polygon>    symmetricDifferenceArray    = new ArrayList<Polygon>();
//ARRAYLIST TO HOLD UNION POLYGONS
ArrayList<Polygon>    unionArray    = new ArrayList<Polygon>();

//for adding points when mouse pressed
Polygon polygns = new Polygon();

boolean unified = false;
Polygon test = new Polygon();


int count = 0, index=0, countS=0;
Point p = new Point(0,0);


Polygon             convexHull = new Polygon();



boolean saveImage = false;

int numOfPoints = 4;
boolean test1 = false;
boolean test2 = false;


void generateRandomPoints(){
  for( int i = 0; i < numOfPoints; i++){
    points.add( new Point( random(100,width-100), random(100,height-100) ) );
  }
}







void setup(){
  size(800,800,P3D);
  frameRate(30);
}


void draw(){
  background(255);
  
  translate( 0, height, 0);
  scale( 1, -1, 1 );
  
  strokeWeight(3);
  
  fill(0);
  noStroke();
  for( Point p : points ){
    p.draw();
  }
  
 
   
   
  
  noFill();
  stroke(100);
  for(Polygon p : polygons)
  {
    
    for( Edge e: p.edges){
      
      e.draw();
      //e.draw();
      
    }
  }
  //THIS IS FOR THE SET DIFFERENCE (TO DRAW IT)
  
  if(finalPolygonArray.size() >= 1)
  for(int i = 0;i<finalPolygonArray.get(finalPolygonArray.size()-1).edges.size();i++)
  {
     
     fill(255,0,0);
     
     Edge e = finalPolygonArray.get(finalPolygonArray.size()-1).edges.get(i);
     stroke(255,0,0);
     e.draw();
  }
  
  

  //DRAWING UNION OF POLYGONS
  for(Polygon polygons : unionArray)
  {
     for(Point p : polygons.p)
     {
       fill(255,0,0);
       p.draw();
     }
     for(Edge e: polygons.edges)
     {
        stroke(255,0,0);
        e.draw();
     }
  }
  
  
  //DRAWING THE SYMMETRIC DIFFERENCE
 for(int i = 0; i<symmetricDifferenceArray.size();i++)
  {
    PShape pgs2 = createShape();
    pgs2.beginShape();
    pgs2.fill(255,0,0);
    
    for(int j = 0; j<symmetricDifferenceArray.get(i).p.size();j++)
    {
       pgs2.vertex(symmetricDifferenceArray.get(i).p.get(j).p.x, symmetricDifferenceArray.get(i).p.get(j).p.y);
    }
    pgs2.endShape(CLOSE);
    symmetricDifferenceArray.get(i).s = pgs2;
    symmetricDifferenceArray.get(i).display();
    
  //}
  }
  
  int colorV = 50;
 
  //DRAWING THE POLYGONS INTERSECTION
  if(polygonsIntersection.size()>=1)
   {
     for(int i = 0 ; i < polygonsIntersection.size(); i++)
     {
        polygonsIntersection.get(i).updateCentroid();
        polygonsIntersection.get(i).sortPoints();
     }
     
   }
  for(int i = 0; i<polygonsIntersection.size();i++)
  {
    PShape pgs2 = createShape();
    pgs2.beginShape();
    pgs2.fill(colorV,0,0);
    colorV += 35;
    for(int j = 0; j<polygonsIntersection.get(i).p.size();j++)
    {
       pgs2.vertex(polygonsIntersection.get(i).p.get(j).p.x, polygonsIntersection.get(i).p.get(j).p.y);
    }
    pgs2.endShape(CLOSE);
    polygonShapes.get(i).s = pgs2;
    polygonShapes.get(i).display();
    
  
  }
  
  stroke( 100, 100, 100 );
  if( convexHull.ccw() ) stroke( 100, 200, 100 );
  if( convexHull.cw()  ) stroke( 200, 100, 100 ); 
  //convexHull.draw();
  
  
  
  
  
  fill(0);
  stroke(0);
  textSize(18);
  
  textRHC( "Controls", 10, height-20 );
  textRHC( "u: union", 10, height-40 );
  textRHC( "I: intersection  ", 10, height-60 );
  textRHC( "s: Set Difference", 10, height-80 );
  textRHC( "c: Clear", 10, height-100);
  textRHC( "d: Symmetric Difference", 10, height-120);
  //textRHC( "s: Save Image", 10, height-100 );
  
  for( int i = 0; i < points.size(); i++ ){
    textRHC( i+1, points.get(i).p.x+5, points.get(i).p.y+15 );
  }
  
  if( saveImage ) saveFrame( ); 
  saveImage = false;
  
  
  

  
  
  
 
   
}


void keyPressed(){
  //if( key == 's' ) saveImage = true;
  
  if( key == '+' ){ numOfPoints++;  }
  if( key == '-' ){ numOfPoints = max( numOfPoints-1, 1 );  }
  
  if( key == 'c' ){ points.clear();  polygons.clear();  polygonsIntersection.clear(); count=0; 
                    polygonShapes.clear(); unionPolygon.clear(); test.p.clear(); unionPolygon2.clear(); symmetricDifferenceArray.clear(); finalPolygonArray.clear(); unionArray.clear();}
  if( key == 'i' ){intersection(polygons); }
  if(key == 'u'){unionAll();}
  if(key == 's'){moreSetDifference();} 
  if(key == 'd'){symmetricDifference();}
            
}



void textRHC( int s, float x, float y ){
  textRHC( Integer.toString(s), x, y );
}


void textRHC( String s, float x, float y ){
  pushMatrix();
  translate(x,y);
  scale(1,-1,1);
  text( s, 0, 0 );
  popMatrix();
}

Point sel = null;

void mousePressed(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  
  float dT = 6;
  for( Point p : points ){
    float d = dist( p.p.x, p.p.y, mouseXRHC, mouseYRHC );
    if( d < dT ){
      dT = d;
      sel = p;
    }
  }
  //ADDING POINTS TO THE POLGONS, LIMITING POLYGONS SIZE TO 5 
  if( sel == null ){
    sel = new Point(mouseXRHC,mouseYRHC);
    points.add( sel );
    points2.add(sel);
    count++;
    if(count%5==0)
    {
        Polygon polygns = new Polygon();
        for(int i=0;i<points2.size();i++)
            polygns.addPoint(points2.get(i));
            
        if(polygons.size()==0)
          polygons.add(polygns);
        else polygons.add(polygns);
        points2.clear();
        
    }
    
  }
    
    
    
    
    
   
  

    
   
   
   
   
}

void mouseDragged(){
  int mouseXRHC = mouseX;
  int mouseYRHC = height-mouseY;
  if( sel != null ){
    sel.p.x = mouseXRHC;   
    sel.p.y = mouseYRHC;
    //calculateConvexHull();
  }
}

void mouseReleased(){
  sel = null;
}




void intersection(ArrayList<Polygon> polygons)
{
  
  
  for(int i = 0;i<polygons.size();i++)
  {
     
       //print(polygons.size());
     
     for(int j = i;j<polygons.size();j++)
     {
        if (i==j)
          continue;
        //THIS WILL BE THE INTESECTIONO POLYGON
        Polygon p6 = new Polygon();
        for(int k = 0;k<polygons.get(i).edges.size();k++)
        {
           
           for(int l = 0; l<polygons.get(j).edges.size(); l++)
           {
             
             //CHECK ALL EDGES TO FIND INTERSECTION POINTS, IF FOUND ADD TO NEW POLYGON CREATED
             p= polygons.get(i).edges.get(k).intersectionPoint(polygons.get(j).edges.get(l));
             fill(255,0,0);
             if(p == null)
               ;
             else {
               p.draw();
               p6.addPoint(p);
               polygons.get(i).edges.get(k).intersect = true;
               polygons.get(j).edges.get(l).intersect = true;
               count++;
               
             }
             
             
             
           }
             //SEE IF THERE ARE POINTS INSIDE THE OTTHER POLYGON
             test1 = polygons.get(j).pointInPolygon(polygons.get(i).p.get(k));
             test2 = polygons.get(i).pointInPolygon(polygons.get(j).p.get(k));
             
             //IF POINT INSIDE, ADD
             if(test1 == true)
             {     
                fill(0,255,0);
                polygons.get(i).p.get(k).draw();
                p6.addPoint(polygons.get(i).p.get(k));
                polygons.get(i).p.get(k).added = true;
                
             }
             //IF POINT INSIDE, ADD
             if(test2==true)
             {  
                p6.addPoint(polygons.get(j).p.get(k));
                count++;
                fill(0,255,0);
                polygons.get(j).p.get(k).draw();
                polygons.get(j).p.get(k).added = true;
                
             }
            
          
        }
        
        setFalse(polygons.get(i));
        setFalse(polygons.get(j));
        if(p6.p.size() >= 3)
        {
          polygonsIntersection.add(p6);
          
        }
          
     }

    
    
    
  }
  
   
     
     //THIS WILL BE USED TO CREATE A PSHAPE, WHICH I CREATE JUST TO COLOR INSIDE OF THE INTERSECTION
     for(int i = 0; i < polygonsIntersection.size();i++)
     {
       Polygon pgs = new Polygon();
       pgs = ConvexHullGiftWrapped(polygonsIntersection.get(i).p);
       polygonShapes.add(pgs);
     }
     
     println("There are " + polygonsIntersection.size() + " polygons intersections " );
     for(int i = 0;i<polygonsIntersection.size();i++)
     {
       println("Polygon " + i + " has " + polygonsIntersection.get(i).p.size() + " points and " + polygonsIntersection.get(i).edges.size() );
     }
     
    
       
        
}

void setFalse(Polygon p){
 
  for(Point points : p.p)
  {
     points.added=false; 
  }
  
}




Polygon getUnion(Polygon p1, Polygon p2)
{

      //creating 2 new graphs
      Graph g1 = new Graph();
      Graph g2 = new Graph();
      float epsilon = .003;
      
     
      println(p1.p.size());
      //adding all the right edges and points to the graph
      for(int i = 0;i<p1.edges.size();i++)
      {
        
        Point x = p1.edges.get(i).getPoint0();
        Point y = p1.edges.get(i).getPoint1();
        g1.addEdge(x,y);
        
      }
      //adding all the right edges and points to the graph
        for(int i = 0;i<p2.edges.size();i++)
      {
        
        Point x = p2.edges.get(i).getPoint0();
        Point y = p2.edges.get(i).getPoint1();
        g2.addEdge(x,y);
        
      }
      
      //CREATE A NEW POLYGON WHICH WILL BE THE UNION    
      Polygon union = new Polygon(); 
     //println(p1.p.size());
     for(int i = 0;i<p1.p.size();i++)
     {
      
      for(int j = 0;j<p2.p.size();j++)
      {
                 //TEST IF POINTS INSIDE OTHER POLYGON
                 test1 = p1.pointInPolygon(p2.p.get(j));
                 if (test1 == false && p2.p.get(j).addedUnion == false){
                 
                 //IF THE POINT IS INDEED INSIDE THE OTHER POLYGON, WE WILL REMOVE IT
                 }else if (test1==true)
                 {
                    
                    g2.removeEdge(p2.p.get(j));
                    g2.points.remove(p2.p.get(j));
                }
         
                test2 = p2.pointInPolygon(p1.p.get(i));
               
             
          
               //IF THE POINT IS INDEED INSIDE THE OTHER POLYGON, WE WILL REMOVE IT
               if (test2 == false && p1.p.get(i).addedUnion == false){
                  
                   p1.p.get(i).addedUnion = true;
               }
               else if (test2==true)
               {
                 
                 g1.removeEdge(p1.p.get(i));
                 
                 g1.points.remove(p1.p.get(i));
                 
                 
               }
          
          
          
          Point intPoint = p1.edges.get(i).intersectionPoint(p2.edges.get(j));
          
          if(intPoint == null)
               ;
          else {
                  
                   
               //union.addPoint(intPoint);
                  //union.addPoint(intPoint);
                  //union.addPoint(p2.p.get(j+1));
                  
                  //if(p2.edges.get(j).intersect == true || p1.edges.get(i).intersect == true)
                           //       ;
                   
                  //getting points from edges
                  Point pointE1 = p1.edges.get(i).getPoint0();
                  Point pointE12 = p1.edges.get(i).getPoint1();
                  Point pointE21 = p2.edges.get(j).getPoint0();
                  Point pointE22 = p2.edges.get(j).getPoint1();
                  
                  
                  
                  //creating new points
                  Point etest11 = new Point(0,0);
                  Point etest22 = new Point(0,0);
                  Point etest33 = new Point(0,0);
                  Point etest44 = new Point(0,0);
                  
                  etest11=null;
                  etest22=null;
                  etest33=null;
                  etest44=null;
                  //creating edges to be added later
                  Edge eTest1 = new Edge(intPoint, pointE1);
                  Edge eTest2 = new Edge(intPoint, pointE12);
                  Edge eTest3 = new Edge(intPoint, pointE21);
                  Edge eTest4 = new Edge(intPoint, pointE22);
                  //checking if point inside of other polygon
                  boolean e1 = p2.pointInPolygon(pointE1);
                  boolean e2 = p2.pointInPolygon(pointE12);
                  boolean e3 = p1.pointInPolygon(pointE21);
                  boolean e4 = p1.pointInPolygon(pointE22);
                  //here im checking if the poitns is in on the line segment
                  for(int m = 0; m<p2.edges.size();m++)
                  {
                    if(etest11 == null)
                    {
                      etest11 = p2.edges.get(m).intersectionPoint(eTest1);
                      if(etest11==null)
                          ;
                      else if(p2.edges.get(m).isBetween(p2.edges.get(m).getPoint0(), etest11, p2.edges.get(m).getPoint1()) == false && Math.abs(etest11.p.x - intPoint.p.x) < epsilon && Math.abs(etest11.p.y - intPoint.p.y) < epsilon)
                      { 
                        //println("hello from the inside");
                          etest11=null;
                      }
                    }
                    if(etest22 == null)
                    {
                      etest22 = p2.edges.get(m).intersectionPoint(eTest2);
                      if(etest22==null)
                          ;
                      else if(p2.edges.get(m).isBetween(p2.edges.get(m).getPoint0(), etest22, p2.edges.get(m).getPoint1()) == false && Math.abs(etest22.p.x - intPoint.p.x) < epsilon && Math.abs(etest22.p.y - intPoint.p.y) < epsilon)
                          etest22=null;
                    }
                    if(etest33 == null)
                    {
                      etest33 = p1.edges.get(m).intersectionPoint(eTest3);
                      if(etest33==null)
                          ;
                      else if(p1.edges.get(m).isBetween(p1.edges.get(m).getPoint0(), etest33, p1.edges.get(m).getPoint1()) == false && Math.abs(etest33.p.x - intPoint.p.x) < epsilon && Math.abs(etest33.p.y - intPoint.p.y) < epsilon)
                          etest33=null;
                    }
                    if(etest44 == null)
                    {
                      etest44 = p1.edges.get(m).intersectionPoint(eTest4);
                      if(etest44==null)
                          ;
                      else if(p1.edges.get(m).isBetween(p1.edges.get(m).getPoint0(), etest44, p1.edges.get(m).getPoint1()) == false && Math.abs(etest44.p.x - intPoint.p.x) < epsilon && Math.abs(etest44.p.y - intPoint.p.y) < epsilon)
                          etest44=null;
                    }
                  }
                  
                  //adding edges from int point to  point from edge that was intersected
                  if(etest11 == null && e1 == false)
                    g1.addEdge(intPoint, pointE1);
                  if(etest22 == null && e2 == false)
                     g1.addEdge(intPoint, pointE12);
                  g1.points.add(intPoint);
                  //removing specific edge
                  g1.removeSpecificEdge(pointE1, pointE12);
                  
                  
                  
                  
                  if(etest33 == null && e3==false)
                    g2.addEdge(intPoint, pointE21);
                  
                   if(etest44 == null && e4==false)
                    g2.addEdge(intPoint, pointE22);
                  g2.points.add(intPoint);
                  g2.removeSpecificEdge(pointE21, pointE22);
                  //REMOVE EDGE ?
                  //p2.p.get(j+1).visit();
                  count++;
                  //g1.draw();
                  //g2.draw();
                  p1.edges.get(i).intersect = true;
                  p2.edges.get(j).intersect = true;
                  
          
          
          
            
       }
       if (test1==true)
       {
                    //REMOVE AGAIN JUST IN CASE
                    g2.removeEdge(p2.p.get(j));
                    g2.points.remove(p2.p.get(j));
       }
       
       if (test2==true)
               {
                
                 g1.removeEdge(p1.p.get(i));
                 g1.points.remove(p1.p.get(i));

                 
               }
       
     
       
       
     }
   }
   //ADDING THE POINTS FROM THE GRAPHS ONTO THE UNION POLYGON
   Iterator it5 = g2.adjacencyMap.entrySet().iterator();
   while(it5.hasNext())
   {
      Map.Entry mapElement3 = (Map.Entry)it5.next();
      Point p = (Point)mapElement3.getKey();
      if(union.p.contains(p));
      else union.p.add(p);
      LinkedList<Point> list = g2.adjacencyMap.get(p);
      if(list == null)
        continue;
      for(int i = 0;i<list.size();i++)
      {  
         
         Edge e1 = new Edge(p, list.get(i));
         if(union.edges.contains(e1));
         else  union.edges.add(e1);
         stroke(255,0,0);
         
      }
   }
   
   Iterator it6 = g1.adjacencyMap.entrySet().iterator();
   while(it6.hasNext())
   {
      Map.Entry mapElement3 = (Map.Entry)it6.next();
      Point p = (Point)mapElement3.getKey();
      if(union.p.contains(p));
      else union.p.add(p);
      LinkedList<Point> list = g1.adjacencyMap.get(p);
      if(list == null)
        continue;
      for(int i = 0;i<list.size();i++)
      {  
         //println("hola");
         Edge e1 = new Edge(p, list.get(i));
         if(union.edges.contains(e1));
         else  union.edges.add(e1);
         stroke(255,0,0);
         //e1.draw();
      }
      
   }
     
   
    unionPolygon2.add(union);
    
  
    
   
   return union;
}
  
void unionAll(){
 
    //THIS FUNCTION WILL UNION ALL POLYGONS
    ArrayList<Polygon> newL = new ArrayList<Polygon>(polygons);
    
    //I KNOW THAT IT IS A WEIRD APPROACH TO UNIONING ALL POLYGONS BUT IT WORKS MOST OF THE TIMES, IT FAILS ON WEIRD CASES
    Polygon ans = new Polygon();
    for(int i = 0;i<newL.size();i++)
    {
     for(int j = 0 ; j< newL.size(); j++)
     {
        for(int k = 0; k<newL.get(i).edges.size();k++)
        {
          
          for(int l = 0;l<newL.get(j).edges.size();l++)
          {
              if(i==j)
                continue;
              if(newL.get(i).edges.get(k).intersectionTest(newL.get(j).edges.get(l)) == true)
              {
                 
                 Graph g = new Graph();
                 ans = getUnion(newL.get(i), newL.get(j));
                 newL.remove(newL.get(i));
                 //println(ans.p.size());
                 newL.remove(newL.get(j-1));
      
                
                for(int m = 0;m<ans.edges.size();m++)
                {
        
                  Point x = ans.edges.get(m).getPoint0();
                  Point y = ans.edges.get(m).getPoint1();
                  g.addEdge(x,y);
        
                }
      
                //ORGANIZING THE GRAPH BY PERFORMING DFS ON IT
                //println(g.adjacencyMap.size());
                for(Point point : ans.p)
                {
                   point.visited = false; 
                }
                g.DFS(ans.p.get(0));
                ans.p.clear();
                ans.edges.clear();
                //ans.edges.clear();
      
              //ADDING THE POINTS IN ORDER
              for(int n=0;n<g.pointsOrdered.size();n++)
                    ans.addPoint(g.pointsOrdered.get(n));
              
      
             newL.add(0, ans);
             j=i;
             
       
           }
          }
              }
          }
          //ADDING UNION TO ARRAYS
          unionArray.add(ans);
        }
        
        
     
  
    
    
}

void symmetricDifference()
{
  
  
  //I GET THE SYMMETRIC DIFFERENCE OF POLYGONS BY BASICALLY DOING SET DIFFERENCE FOR ALL POLYGONS
  int count = 0;
  while(count<polygons.size())
  {
     Polygon m = moreSymmetricDifference();
     symmetricDifferenceArray.add(m);
     count++;
     if(count == polygons.size())
       continue;
     Polygon p = polygons.get(count);
     polygons.remove(count);
     polygons.add(0,p);
     
  }
    
}

Polygon setDifference(Polygon p1, Polygon p2)
{
      Graph g1 = new Graph();
      Graph g2 = new Graph();
      float epsilon = .003;
      
     //I BASICALLY USED THE SAME ALGORITHM THAT I USED FOR THE UNION BUT I MODIFIED IT A LITTLE BIT 
      println(p1.p.size());
      
      //GETTING GRAPHS, SAME AS FOR THE UNION
      for(int i = 0;i<p1.edges.size();i++)
      {
        
        Point x = p1.edges.get(i).getPoint0();
        Point y = p1.edges.get(i).getPoint1();
        g1.addEdge(x,y);
        
      }
      
        for(int i = 0;i<p2.edges.size();i++)
      {
        
        Point x = p2.edges.get(i).getPoint0();
        Point y = p2.edges.get(i).getPoint1();
        g2.addEdge(x,y);
        
      }
      
          
      Polygon union = new Polygon(); 
     
     for(int i = 0;i<p1.p.size();i++)
     {
      
      for(int j = 0;j<p2.p.size();j++)
      {
        
                 test1 = p1.pointInPolygon(p2.p.get(j));
                 if (test1 == false  ){
                 
                 }else if (test1==true)
                 {
                    
                    
                }
         
                test2 = p2.pointInPolygon(p1.p.get(i));
               
             
          
               
               if (test2 == false && p1.p.get(i).addedUnion == false){
                   
                   p1.p.get(i).addedUnion = true;
               }
               else if (test2==true)
               {
                 
                 println("before remove "+ g1.adjacencyMap.size());
                 
                 g1.removeEdge(p1.p.get(i));
                 println("after remove "+ g1.adjacencyMap.size());
                 g1.points.remove(p1.p.get(i));
                 
                 
               }
          
          
          
          
          boolean intersect = p1.edges.get(i).intersectionTest(p2.edges.get(j));
          if(intersect == false)
               ;
          else {
                  
                           
                  
                //union.addPoint(intPoint);
                  //union.addPoint(intPoint);
                  //union.addPoint(p2.p.get(j+1));
                  
                  //if(p2.edges.get(j).intersect == true || p1.edges.get(i).intersect == true)
                           //       ;
                           
                           
                  
                  
                  //doing same as union algorithm
                  Point intPoint = p1.edges.get(i).intersectionPoint(p2.edges.get(j));
                  
                  Point pointE1 = p1.edges.get(i).getPoint0();
                  Point pointE12 = p1.edges.get(i).getPoint1();
                  Point pointE21 = p2.edges.get(j).getPoint0();
                  Point pointE22 = p2.edges.get(j).getPoint1();
                  
                  
                  
                  
                  Point etest11 = new Point(0,0);
                  Point etest22 = new Point(0,0);
                  Point etest33 = new Point(0,0);
                  Point etest44 = new Point(0,0);
                  
                  etest11=null;
                  etest22=null;
                  etest33=null;
                  etest44=null;
                  
                  Edge eTest1 = new Edge(intPoint, pointE1);
                  Edge eTest2 = new Edge(intPoint, pointE12);
                  Edge eTest3 = new Edge(intPoint, pointE21);
                  Edge eTest4 = new Edge(intPoint, pointE22);
                  
                  boolean e1 = p2.pointInPolygon(pointE1);
                  boolean e2 = p2.pointInPolygon(pointE12);
                  boolean e3 = p1.pointInPolygon(pointE21);
                  boolean e4 = p1.pointInPolygon(pointE22);
                  
                  if(e3==true)
                  ;
                    //g1.addEdge(intPoint, pointE21);
                  else if (e4 == true)
                  ;
                    //g1.addEdge(intPoint, pointE22);
                  for(int m = 0; m<p2.edges.size();m++)
                  {
                    if(etest11 == null)
                    {
                      etest11 = p2.edges.get(m).intersectionPoint(eTest1);
                      if(etest11==null)
                          ;
                      else if(p2.edges.get(m).isBetween(p2.edges.get(m).getPoint0(), etest11, p2.edges.get(m).getPoint1()) == false && Math.abs(etest11.p.x - intPoint.p.x) < epsilon && Math.abs(etest11.p.y - intPoint.p.y) < epsilon)
                      { 
                        //println("hello from the inside");
                          etest11=null;
                      }
                    }
                    if(etest22 == null)
                    {
                      etest22 = p2.edges.get(m).intersectionPoint(eTest2);
                      if(etest22==null)
                          ;
                      else if(p2.edges.get(m).isBetween(p2.edges.get(m).getPoint0(), etest22, p2.edges.get(m).getPoint1()) == false && Math.abs(etest22.p.x - intPoint.p.x) < epsilon && Math.abs(etest22.p.y - intPoint.p.y) < epsilon)
                          etest22=null;
                    }
                    if(etest33 == null)
                    {
                      etest33 = p1.edges.get(m).intersectionPoint(eTest3);
                      if(etest33==null)
                          ;
                      else if(p1.edges.get(m).isBetween(p1.edges.get(m).getPoint0(), etest33, p1.edges.get(m).getPoint1()) == false && Math.abs(etest33.p.x - intPoint.p.x) < epsilon && Math.abs(etest33.p.y - intPoint.p.y) < epsilon)
                          etest33=null;
                    }
                    if(etest44 == null)
                    {
                      etest44 = p1.edges.get(m).intersectionPoint(eTest4);
                      if(etest44==null)
                          ;
                      else if(p1.edges.get(m).isBetween(p1.edges.get(m).getPoint0(), etest44, p1.edges.get(m).getPoint1()) == false && Math.abs(etest44.p.x - intPoint.p.x) < epsilon && Math.abs(etest44.p.y - intPoint.p.y) < epsilon)
                          etest44=null;
                    }
                  }
                  
                  if(etest11 == null && e1 == false)
                    g1.addEdge(intPoint, pointE1);
                  if(etest22 == null && e2 == false)
                     g1.addEdge(intPoint, pointE12);
                  g1.points.add(intPoint);
                  g1.removeSpecificEdge(pointE1, pointE12);
                  
                  
                  
                  //instead of adding if e3 and e4 are false(point outside) add if the point is inside 
                  if(e3==true && etest33 == null)
                    g2.addEdge(intPoint, pointE21);
                  
                   if(e4==true && etest44 == null)
                    g2.addEdge(intPoint, pointE22);
                  g2.points.add(intPoint);
                  g2.removeSpecificEdge(pointE21, pointE22);
                  //REMOVE EDGE ?
                  //p2.p.get(j+1).visit();
                  count++;
                  //g1.draw();
                  //g2.draw();
                  p1.edges.get(i).intersect = true;
                  p2.edges.get(j).intersect = true;
                 
                  
          
          
          
            
       }
       if (test1==false)
       {
                    
                    g2.removeEdge(p2.p.get(j));
       }
       
       if (test2==true)
               {
                 
                 g1.removeEdge(p1.p.get(i));
                 g1.points.remove(p1.p.get(i));

                 
               }
       
     
       
       
     }
   }
   
   //ADDING POINTS FROM THE GRAPHS TO THE POLYGONS
   for(int i = 0;i<g2.adjacencyMap.size();i++)
   {
     if(i>=p2.p.size())
       continue;
     if(p1.pointInPolygon(p2.p.get(i)));
       
   }
   Iterator it5 = g2.adjacencyMap.entrySet().iterator();
   while(it5.hasNext())
   {
      Map.Entry mapElement3 = (Map.Entry)it5.next();
      Point p = (Point)mapElement3.getKey();
      if(union.p.contains(p));
      else union.p.add(p);
      LinkedList<Point> list = g2.adjacencyMap.get(p);
      if(list == null)
        continue;
      for(int i = 0;i<list.size();i++)
      {  
         //println("hola");
         Edge e1 = new Edge(p, list.get(i));
         if(union.edges.contains(e1));
         else  union.edges.add(e1);
         stroke(255,0,0);
         //e1.draw();
      }
   }
   
   Iterator it6 = g1.adjacencyMap.entrySet().iterator();
   while(it6.hasNext())
   {
      Map.Entry mapElement3 = (Map.Entry)it6.next();
      Point p = (Point)mapElement3.getKey();
      if(union.p.contains(p));
      else union.p.add(p);
      LinkedList<Point> list = g1.adjacencyMap.get(p);
      if(list == null)
        continue;
      for(int i = 0;i<list.size();i++)
      {  
         //println("hola");
         Edge e1 = new Edge(p, list.get(i));
         if(union.edges.contains(e1));
         else  union.edges.add(e1);
         stroke(255,0,0);
         //e1.draw();
      }
      
   }
     
   
   return union;
  
}

void moreSetDifference()
{
        //GETTING SET DIFFERENCE OF VARIOUS POLYGONS
       int count = 0;
       ArrayList<Polygon>    setPolygons     = new ArrayList<Polygon>();
       Polygon p = setDifference(polygons.get(0), polygons.get(1));
       setPolygons.add(p);
       
      
     if(polygons.size() < 3)
     {
       //setPolygons.add(p);
       finalPolygonArray.add(p);
       return;
     }
     else{ 
     for(int i = 2 ; i<polygons.size();i++)
     { 
        
            Graph g = new Graph();
          
     
      
            println("p edges size is " + setPolygons.get(count).edges.size());
            for(int j = 0;j<setPolygons.get(count).edges.size();j++)
            {
        
              Point x = setPolygons.get(count).edges.get(j).getPoint0();
              Point y = setPolygons.get(count).edges.get(j).getPoint1();
              g.addEdge(x,y);
        
            }
      
            println("adjacency map at " + i + " is " + g.adjacencyMap.size());
        //println(g.adjacencyMap.size());
            println("polygon point size at " + i + "is" + setPolygons.get(count).p.size());
            for(Point point : setPolygons.get(count).p)
            {
               point.visited = false; 
            }
            //ORGANIZING POLYGONS WITH DFS
            g.DFS(setPolygons.get(count).p.get(0));
            setPolygons.get(count).p.clear();
            setPolygons.get(count).edges.clear();
        //println(g.pointsOrdered.size());
            println("point ordered size at "+  i +  "is " + g.pointsOrdered.size());
            for(int l=0;l<g.pointsOrdered.size();l++)
                setPolygons.get(count).addPoint(g.pointsOrdered.get(l));
            
            //SET POLYGONS HAS THE PREVIOUS ANSWER, SO COMPARE THAT TO THE NEXT POLYGON AND SO ON
            Polygon p3 = setDifference(setPolygons.get(count), polygons.get(i));
            
            println("P3 SIZE IS: " + p3.p.size());
            println("P3 EDGES SIZE IS: " + p3.edges.size());
            setPolygons.add(p3);
            
            count++;
            //finalPolygonArray.add(setPolygons.get(count));
            finalPolygonArray.add(p3);
        
    
    
       }
      
     }
     
     
 
           
}

Polygon moreSymmetricDifference()
{
        //THIS FUNCTIOON IS THE SAME AS THE ONE "moreSetDifference" BUT IT ORGANIZES THE POINTS OF THE FINAL POLYGON ONE LAST TIME AND IT ADDS IT
       int count = 0;
       ArrayList<Polygon>    setPolygons     = new ArrayList<Polygon>();
       Polygon p = setDifference(polygons.get(0), polygons.get(1));
       setPolygons.add(p);
       
      
     if(polygons.size() < 3)
     {
       
       symmetricDifferenceArray.add(p);
       return p;
     }
     else{ 
     for(int i = 2 ; i<polygons.size();i++)
     { 
        
            Graph g = new Graph();
          
     
      
            println("p edges size is " + setPolygons.get(count).edges.size());
            for(int j = 0;j<setPolygons.get(count).edges.size();j++)
            {
        
              Point x = setPolygons.get(count).edges.get(j).getPoint0();
              Point y = setPolygons.get(count).edges.get(j).getPoint1();
              g.addEdge(x,y);
        
            }
      
            println("adjacency map at " + i + " is " + g.adjacencyMap.size());
       
            println("polygon point size at " + i + "is" + setPolygons.get(count).p.size());
            for(Point point : setPolygons.get(count).p)
            {
               point.visited = false; 
            }
            g.DFS(setPolygons.get(count).p.get(0));
            setPolygons.get(count).p.clear();
            setPolygons.get(count).edges.clear();
        //println(g.pointsOrdered.size());
            println("point ordered size at "+  i +  "is " + g.pointsOrdered.size());
            for(int l=0;l<g.pointsOrdered.size();l++)
                setPolygons.get(count).addPoint(g.pointsOrdered.get(l));
            
            //symmetricDifferenceArray.add( setPolygons.get(count));
            Polygon p3 = setDifference(setPolygons.get(count), polygons.get(i));
            
            println("P3 SIZE IS: " + p3.p.size());
            println("P3 EDGES SIZE IS: " + p3.edges.size());
            setPolygons.add(p3);
            
            count++;
            //finalPolygonArray.add(setPolygons.get(count));
            
        
    
    
       }
       //HERE IM ORGANIZING THE EDGES AND POINTS OF THE LAST POLYGON THAT WAS STORED SO THAT I CAN GET THE PSHAPE, IT MIGHT DRAW THE LAST PSHAPE WEIRDLY IN SOME DEGENERATE CASES
           Graph g2 = new Graph();
          
     
      
            println("p edges size is " + setPolygons.get(count).edges.size());
            for(int j = 0;j<setPolygons.get(count).edges.size();j++)
            {
        
              Point x = setPolygons.get(count).edges.get(j).getPoint0();
              Point y = setPolygons.get(count).edges.get(j).getPoint1();
              g2.addEdge(x,y);
        
            }
      
           
            for(Point point : setPolygons.get(count).p)
            {
               point.visited = false; 
            }
            g2.DFS(setPolygons.get(count).p.get(0));
            setPolygons.get(count).p.clear();
            setPolygons.get(count).edges.clear();
        //println(g.pointsOrdered.size());
            
            for(int l=0;l<g2.pointsOrdered.size();l++)
                setPolygons.get(count).addPoint(g2.pointsOrdered.get(l));
            
            return setPolygons.get(count);
            //symmetricDifferenceArray.add( setPolygons.get(count));
      
     }
     
     //ADD TO SYMMETRIC DIFFERENCE ONE LAST TIME
 
           
}
