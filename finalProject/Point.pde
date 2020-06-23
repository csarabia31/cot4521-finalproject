

class Point implements Comparable<Point> {
  
   public PVector p;
   //A FEW BOOLEANS TO CHECK IF POINTS HAVE BEEN ADDED
   public boolean added = false;
   public boolean addedUnion = false;
   int count = 0;
   //FOR DFS
   boolean visited;
   
   
  
   
   double angle;
   
   public Point( float x, float y ){
     p = new PVector(x,y);
   }

   public Point(PVector _p0 ){
     p = _p0;
   }
   
   public void draw(){
     ellipse( p.x,p.y, 10,10);
   }
   

   
   float x(){ return p.x; }
   float y(){ return p.y; }
   
   public void visit(){
     visited=true;
   }
   
   public void unvisit(){
     visited=false;
   }
   
   boolean isVisited(){
     if(this.visited == true)
       return true;
     else return false;
   }
   
   public float distance( Point o ){
     return PVector.dist( p, o.p );
   }
   
   public String toString(){
     return p.toString();
   }
   
   public double angle(){
      return angle;
      
   }
   
   public int  compareTo(Point compareto){
     
     if(compareto.angle() > this.angle) return 1;
     if(compareto.angle() < this.angle) return -1;
     return 0;
    
     
   }
   
   
}
