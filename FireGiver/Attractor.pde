class Attractor extends Node
{
  // Editable Values
  float radius = 80;
  float forceScale = .8;
  
  // Non-Editable Values
  float force;
  float distance;
  float angle;
  float dx;
  float dy;
  float s;
  
  Attractor(float _x, float _y)
  {
    super(_x, _y);  
    damping = 0;
    maxVelocity = 100;
  }
  
  void Display()
  {
    fill(0, 255, 0);
    ellipse(x, y, 10, 10);
  }
  
  void Attract()
  {
    for(int i = 0; i < nodeNumber; i++)
    { 
      dx = x - nodes.get(i).x;
      dy = y - nodes.get(i).y;
      distance = mag(dx, dy);
      
      if(distance > 0 && distance < radius)
      {
        s = distance / radius;
        force = (1f / pow(s, .5)) - 1;
        force = force / radius;
        force = force * forceScale;
        nodes.get(i).velocity.x += force * dx;
        nodes.get(i).velocity.y += force * dy;
      }
    }
  }
}