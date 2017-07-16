class Node
{
  // Editable Values
  float diameter;
  float minDiameter = 5;
  float maxDiameter = 30;
  float maxVelocity = 1.8;
  float damping = .003;
  float errorBound = 1;
  float timeSinceStoppedMax = 10000;
  float bValueMax = 150;
  float deathTime = 30000;
  float minDeathTime = 1000;
  float deathTimeStep = 5;
  
  // Non-Editable Values
  float x;
  float y;
  float radius;
  PVector velocity = new PVector();
  float minX = 5;
  float minY = 5;
  float maxX = width - 5;
  float maxY = height - 5;
  float rValue;
  float bValue;
  float timeAtStop;
  float timeSinceStopped;
  float velocityThresholdForColor = .2;
  float totalTimeSinceStopped;
  public boolean destroyed = false;
  
  Node(float _x, float _y, float _minX, float _minY, float _maxX, float _maxY)
  {
    x = _x;
    y = _y;
    
    minX = _minX;
    minY = _minY;
    maxX = _maxX;
    maxY = _maxY;
  }
  
  Node(float _x, float _y)
  {
    x = _x;
    y = _y;
  }
  
  void Update()
  {
    if(deathTime - deathTimeStep > minDeathTime) deathTime -= deathTimeStep;
    println(deathTime);
    
    x += velocity.x;
    y += velocity.y;
    
    if(velocity.x > maxVelocity) velocity.x = maxVelocity;
    if(velocity.y > maxVelocity) velocity.y = maxVelocity;
    
    BoundsCheck();
    
    velocity.x *= (1 - damping);
    velocity.y *= (1 - damping);
    
    if(mag(velocity.x, velocity.y) < velocityThresholdForColor) {
      timeSinceStopped = millis() - timeAtStop;  
      totalTimeSinceStopped = millis() - timeAtStop;
    } else {
      timeAtStop = millis();
      timeSinceStopped = 0;
    }
    
    if(totalTimeSinceStopped > deathTime) destroyed = true;
  }  
  
  void DrawDot()
  {
    float resultantVelocity = sqrt(pow(velocity.x, 2) + pow(velocity.y, 2));
    float maxResultantVelocity = sqrt(pow(maxVelocity, 2) + pow(maxVelocity, 2));
    rValue = map(resultantVelocity, 0, maxResultantVelocity, 20, 255);
    diameter = map(resultantVelocity, 0, maxResultantVelocity, minDiameter, maxDiameter);
    radius = diameter / 2;
    if(timeSinceStopped > timeSinceStoppedMax) timeSinceStopped = timeSinceStoppedMax;
    bValue = map(timeSinceStopped, 0, timeSinceStoppedMax, 0, bValueMax);
    if(timeSinceStopped > 1000) fill(0, 0, bValue);
    else fill(rValue, 0, 0);
    ellipse(x, y, diameter, diameter);
  }
  
  
  void BoundsCheck()
  {
    if(x + radius > maxX)
    {
      x = maxX - radius - errorBound;
      velocity.x = -velocity.x;
    }
    
    if(x - radius < minX)
    {
      x = minX + radius + errorBound;
      velocity.x = -velocity.x;
    }
    
    if(y - radius < minY)
    {
      y = minY + radius + errorBound;
      velocity.y = -velocity.y;
    }
    
    if(y + radius > maxY)
    {
      y = maxY - radius - errorBound;
      velocity.y = -velocity.y;  
    }
  }
}