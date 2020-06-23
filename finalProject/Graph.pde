

class Graph{
  
    //CREATING A GRAPH WITH A HASHMAP CONTAINING A POINT AND A LIST FOR EVERY POINT
    private HashMap<Point, LinkedList<Point>> adjacencyMap;
    ArrayList<Edge>     edges  = new ArrayList<Edge>();
    ArrayList<Point>     points  = new ArrayList<Point>();
    ArrayList<Point> pointsOrdered = new ArrayList<Point>();
    
    
    public Graph(){
       adjacencyMap = new HashMap();
       
    }
     void addPoint( Point _p )
     { 
       points.add( _p ); 
       if( points.size() == 2 ){
         //edges.add( new Edge( points.get(0), points.get(1) ) );
         //edges.add( new Edge( points.get(1), points.get(0) ) );
         addEdge( points.get(0), points.get(1) );
         
     }
       if( points.size() > 2 ){
         //edges.set( edges.size()-1, new Edge( points.get(points.size()-2), points.get(points.size()-1) ) );
         //edges.add( new Edge( points.get(points.size()-1), points.get(0) ) );
         addEdge(points.get(points.size()-2), points.get(points.size()-1) );
         //addEdge( points.get(points.size()-1), points.get(0)  );
         
         
         
     }
     if(points.size()>4)
     {
       addEdge( points.get(points.size()-1), points.get(0)  );
     }
     
    //updateCentroid();
    
    //sortPoints();
 
 
   }
   
   
    void draw(){
     int N = points.size();
     for(int i = 0; i < N; i++ ){
       line( points.get(i).x(), points.get(i).y(), points.get((i+1)%N).x(), points.get((i+1)%N).y() );
       
       
     }
   }
    //ADDING THE EDGES
    public void addEdgeHelper(Point a, Point b) {
    LinkedList<Point> list = adjacencyMap.get(a);

      if (list != null) {
          list.remove(b);
      }
      else list = new LinkedList();
      list.add(b);
      adjacencyMap.put(a,list);
    }
    
    //ADDING EDGES
    public void addEdge(Point source, Point destination) {

      Edge e = new Edge(source, destination);
      
      edges.add(e);
      if(this.points.size() == 2)
      { Edge e2 = new Edge( points.get(1), points.get(0) );
        edges.add(e2);
        
      }
      
      
      if (!adjacencyMap.keySet().contains(source))
          adjacencyMap.put(source, null);

      if (!adjacencyMap.keySet().contains(destination))
          adjacencyMap.put(destination, null);

      addEdgeHelper(source, destination);
      addEdgeHelper(destination, source);
    
  }
  
  //REMOVING EDGES FROM GRAPH
  public void removeEdge(Point a)
  {
    adjacencyMap.remove(a);
    Iterator it = adjacencyMap.entrySet().iterator();
    while(it.hasNext())
     {
      Map.Entry mapElement3 = (Map.Entry)it.next();
      Point p = (Point)mapElement3.getKey();
      LinkedList<Point> list = adjacencyMap.get(p);
      if(list == null)
        continue;
      if(list.contains(a))
        list.remove(a);
      //else println("POINT A NOT FOUND");
   }
    
  }
  //REMOVE A SPECIFIC EDGE
  public void removeSpecificEdge(Point p0, Point p1)
  {
     LinkedList<Point> list = adjacencyMap.get(p0);
     if(list == null)
        ;
     else if(list.contains(p1))
     {  
         
         list.remove(p1);
     }   
     list = adjacencyMap.get(p1);
     if(list == null)
           ;
     else if(list.contains(p0))
     { 
       list.remove(p0);
     }
  }
  //DRAWING THE GRAPH
  public void drawGraph(Point p){
     edges.clear();
     LinkedList<Point> neighbors = adjacencyMap.get(p);
     for(Point neighbor : neighbors)
     {
        Edge e = new Edge(p, neighbor);
        edges.add(0,e);
     }
    
  }
  //GET SIZE OF THE NEIGHBOURS
  public int getNeighborsSize(Point p)
  {
      LinkedList<Point> neighbors = adjacencyMap.get(p);
      if (neighbors!=null)
        return neighbors.size();
      else return 0;
    
  }
  
  //DFS TO ORDER POINTS/EDGES
  public void DFS(Point p) {
    p.visit();
    //System.out.print(node.name + " ");
    pointsOrdered.add(p);
    
    LinkedList<Point> neighbors = adjacencyMap.get(p);
    if (neighbors == null)
        return;
  

    for (Point neighbor : neighbors) {
        if (!neighbor.isVisited())
           DFS(neighbor);
        
    }
  }
  //CHECKING IF AN EDGE EXISTS
  public boolean hasEdge(Point source, Point destination) {
    return adjacencyMap.containsKey(source) && adjacencyMap.get(source).contains(destination);
  }
}
