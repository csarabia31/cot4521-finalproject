

class Polygon {
  
   ArrayList<Point> p = new ArrayList<Point>();
   ArrayList<Edge>     edges  = new ArrayList<Edge>();
   PShape s;
   PVector centroid;
   
   boolean polygonUnioned= false;
   Polygon( ){ }
   
   public Polygon(Polygon other)
   {
    this.p = new ArrayList<Point>(other.p);
    this.edges = new ArrayList<Edge>(other.edges);
    this.centroid = other.centroid;
    this.s= other.s;
   }
   void display(){
     shape(s); 
   }
   void draw(){
     int N = p.size();
     for(int i = 0; i < N; i++ ){
       line( p.get(i).x(), p.get(i).y(), p.get((i+1)%N).x(), p.get((i+1)%N).y() );
       
       
     }
   }
   
   void addPoint( Point _p )
   { 
     p.add( _p ); 
     if( p.size() == 2 ){
       edges.add( new Edge( p.get(0), p.get(1) ) );
       edges.add( new Edge( p.get(1), p.get(0) ) );
     }
     if( p.size() > 2 ){
       edges.set( edges.size()-1, new Edge( p.get(p.size()-2), p.get(p.size()-1) ) );
       edges.add( new Edge( p.get(p.size()-1), p.get(0) ) );
     }
     
    //updateCentroid();
    
    //sortPoints();
 
 
   }
   //GETTING THE CENTROID OF A SET OF POINTS
   void updateCentroid() {
    centroid = new PVector();
    for (Point p : p) {
      centroid.add(p.p);
    } 
    centroid.div(p.size());
  }
  
  //SORTING THE POINTS, THIS IS USED IN MY INTERSECTION FUNCTION
  void sortPoints() {

    
    ArrayList<Point> newPoints = new ArrayList<Point>();

    
    while (!p.isEmpty ()) {
      //the highest angle
      float biggestAngle = 0;
      Point biggestVertex = null;
      // Look through all of them
      for (Point v : p) {
        // Make a vector that points from center
        PVector dir = PVector.sub(v.p, centroid);
        
        float a = dir.heading() + PI;
        // found it?
        if (a > biggestAngle) {
          biggestAngle = a;
          biggestVertex = v;
        }
      }

      
      newPoints.add(biggestVertex);
      
      p.remove(biggestVertex);
    }
    
    p = newPoints;
  }

   //POINT IN POLYGON FUNCTION
   
   boolean pointInPolygon(Point p3){
     int count = 0;
     float intersection;
     float epsilon = 0.003;
     Point p1, p2;
     
     p1 = p.get(0);
     for(int i = 1;i <= p.size(); i++)
     {
       
       p2 = p.get(i % p.size());
         if(p3.p.y > min(p1.p.y, p2.p.y))
         {
           if(p3.p.y <= max(p1.p.y, p2.p.y))
           {
             if(p3.p.x <= max(p1.p.x, p2.p.x))
             {
               if(p1.p.y != p2.p.y)
               {
                 intersection = (p3.p.y - p1.p.y)*(p2.p.x-p1.p.x)/(p2.p.y-p1.p.y)+p1.p.x;
                 if(p1.p.x == p2.p.x || p3.p.x  <= intersection + epsilon)
                 count++;
               }
             }
           }
         }
         p1=p2;
     }
      
     if(count % 2 == 0)
       return false;
     else return true;
     
   }
   ArrayList<Edge> getBoundary(){
     return edges;
   }
   
   

   boolean isClosed(){ return p.size()>=5; }
   boolean isSimple(){ return false; }
   boolean ccw(){ return false; }
   boolean cw(){ return false; }
   
   
   
}
