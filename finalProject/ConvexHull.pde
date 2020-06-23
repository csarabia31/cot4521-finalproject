

Polygon ConvexHullGiftWrapped( ArrayList<Point> points ){
  Polygon cHull = new Polygon();
  float minY=0;
  int index = 0, index2=0;
  double minAngle = 10000.00;
  for(int i = 0;i<points.size();i++)
  {
    if(i==0)
    {
      minY = points.get(i).p.y;
      index = i;
    }
    else
    {
      if (minY < points.get(i).p.y)
            ;
      else if (minY > points.get(i).p.y)
      {
        minY = points.get(i).p.y;
        index = i;
      }
            
    }
      
    
  }
  int count = 0;
  int count2 = 0;
  int cHullSize = 0;
  double a = 0;
  //println(points.size());
  while(count < points.size())
  {
    //if(count <= 1)
    cHull.addPoint(points.get(index));
    float firstPx = cHull.p.get(0).p.x;
    float firstPy = cHull.p.get(0).p.y;
    
    float lastPx = points.get(index).p.x;
    float lastPy = points.get(index).p.y;
    
    if(firstPx == lastPx && firstPy == lastPy && count>0)
      {
        cHull.addPoint(points.get(index));
        break;
        
      }
        
     //println(points.size());
    //println(count);
    for(int i=0;i<points.size();i++)
    {
        if(i==index)
          continue;
        if(count == points.size()-1)
        continue;
      
      if(count<=0)
      {
        PVector v = new PVector(points.get(i).p.x - points.get(index).p.x, points.get(i).p.y - points.get(index).p.y);
        PVector v2 = new PVector((points.get(index).p.x * 10) , points.get(index).p.y);
        a = PVector.angleBetween(v,v2);
       
       
      }
      else 
      {        cHullSize = cHull.p.size();
               PVector v = new PVector(points.get(i).p.x - points.get(index).p.x, points.get(i).p.y - points.get(index).p.y);
               PVector v2 = new PVector(points.get(index).p.x - cHull.p.get(cHullSize-2).p.x, points.get(index).p.y - cHull.p.get(cHullSize-2).p.y);
               a = PVector.angleBetween(v2,v);
               //println(a);
                //count2++;
                //println(count2); 
               
      }
      
        if(a<minAngle)
        {
           minAngle = a;
           index2=i;
        }
    
    }
    
    //cHull.addPoint(points.get(index));
    //cHull.addPoint(points.get(index2));
    //cHull.addPoint(points.get(index));
    index = index2;
    
    minAngle = 10000.00;  
    count++;
  }
  return cHull;
}
