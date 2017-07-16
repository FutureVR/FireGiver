import controlP5.*;

// Editable Values
int attractorNumber = 4;
float gridSizeX = 40;
float gridSizeY = 40;
float minNodeVelocity = -1;
float maxNodeVelocity = 1;
float minAttractorVelocity;
float maxAttractorVelocity;

// Non-Editable Values
float nodeNumber = gridSizeX * gridSizeY;
float gridLengthX;
float gridLengthY;
ArrayList<Node> nodes;
ArrayList<Attractor> attractors;

float maxX;
float minX;
float maxY;
float minY;

//Buttons
// 1) Pause
// 2) Restart
//Sliders
// 3) attractorNumber

int buttonWidth = 200;
int buttonHeight = 50;
int buttonVerticalOffset = 56;

int sliderWidth = 200;
int sliderHeight = 32;
int sliderVerticalOffset = 40;

Button pauseButton;
Button restartButton;
Slider attractorNumberSlider;
Slider minAttractorVelocitySlider;
Slider maxAttractorVelocitySlider;

ControlP5 cp5;
boolean paused;


void setup()
{
  size(1200, 1200);
  background(255);
  randomSeed(0);
  
  attractors = new ArrayList<Attractor>();
  nodes = new ArrayList<Node>();
  
  paused = false;
  cp5 = new ControlP5(this);
  
  // Setup the UI
  restartButton = createButton("RESTART", width - buttonWidth - 10, 10, buttonWidth, buttonHeight);
  pauseButton = createButton("PAUSE", width - buttonWidth - 10, 10 + buttonVerticalOffset, buttonWidth, buttonHeight);
  attractorNumberSlider = createSlider("NUM_OF_ATTRACTORS", 10, 10, sliderWidth, sliderHeight, 1, 20, 8);
  attractorNumberSlider.setNumberOfTickMarks(20).setDecimalPrecision(0);
  minAttractorVelocitySlider = createSlider("MIN_VELOCITY", 10, 10 + buttonVerticalOffset, 
      sliderWidth, sliderHeight, 0, 10, 5);
  maxAttractorVelocitySlider = createSlider("MAX_VELOCITY", 10, 10 + buttonVerticalOffset * 2, 
      sliderWidth, sliderHeight, 0, 20, 10);

  
  // Create grid
  
  gridLengthX = width / gridSizeX;
  gridLengthY = height / gridSizeY;
  
  InitializeNodes();
  createAttractors();
} 

void draw()
{
  if (!paused)
  {
    background(255);
    
    MakeGrid();
    
    for(int i = 0; i < nodeNumber; i++)   
    {
      if(nodes.get(i).destroyed == false) nodes.get(i).Update();
      if(nodes.get(i).destroyed == false) nodes.get(i).DrawDot();
    }
    
    for(int i = 0; i < attractorNumber; i++)   
    {
      attractors.get(i).Update();
      attractors.get(i).Attract();
      //attractors[i].Display();
    }
  }
}

void mouseClicked()
{
  /*for(int i = 0; i < nodeNumber; i++)
  {
    nodes[i].x = mouseX;
    nodes[i].y = mouseY;
    
    nodes[i].velocity.x = random(minNodeVelocity, maxNodeVelocity);
    nodes[i].velocity.y = random(minNodeVelocity, maxNodeVelocity);
  }*/
}

void InitializeNodes()
{
  for(int y = 0; y < gridSizeY; y++)
  {
    for(int x = 0; x < gridSizeX; x++)
    {     
      //translate(gridLengthX / 2, gridLengthY / 2);
      nodes.add( new Node(x * gridLengthX + gridLengthX / 2, y * gridLengthY + gridLengthY / 2, 
              x * gridLengthX, y * gridLengthY, (x + 1) * gridLengthX, (y + 1) * gridLengthY) );
      nodes.get(nodes.size()-1).velocity.x = random(minNodeVelocity, maxNodeVelocity);
      nodes.get(nodes.size()-1).velocity.y = random(minNodeVelocity, maxNodeVelocity);
    }
  }  
}

void createAttractors()
{
  // Create attractors
  attractorNumber = (int)attractorNumberSlider.getValue();

  for(int i = 0; i < attractorNumber; i++)
  {
    //randomSeed(i);
    int maxX = width - 5;
    int minX = 5;
    int minY = 5;
    int maxY = height - 5;
    
    minAttractorVelocity = minAttractorVelocitySlider.getValue();
    maxAttractorVelocity = maxAttractorVelocitySlider.getValue();
    
    attractors.add( new Attractor(random(0, maxX), random(minY, maxY)) );
    attractors.get(i).velocity.x = random(minAttractorVelocity, maxAttractorVelocity) * (((int)random(0, 2) == 0) ? 1 : -1);
    attractors.get(i).velocity.y = (random(minAttractorVelocity, maxAttractorVelocity)) * (((int)random(0, 2) == 0) ? 1 : -1);
  }
}

void MakeGrid()
{  
  for(int x = 0; x <= width; x += gridLengthX)
  {
    line(x, 0, x, height);  
  }
  
  for(int y = 0; y <= height; y += gridLengthY)
  {
    line(0, y, width, y);  
  }
}


public void controlEvent(ControlEvent theEvent) 
{
  Controller object = theEvent.getController();
  
  if (object == pauseButton)
  {
    paused = !paused;
  }
  else if (object == restartButton)
  {
    attractors.clear();
    nodes.clear();
    InitializeNodes();
    createAttractors();
  }
}

Button createButton(String name, int x, int y, int myWidth, int myHeight)
{
  Button button = cp5.addButton(name);
  button.setValue(0).setPosition(x, y).setSize(myWidth, myHeight);
  button.getCaptionLabel().setSize(myWidth / 10);
  return button;
}

Slider createSlider(String name, int x, int y, 
    int myWidth, int myHeight, float min, float max, float value)
{

  Slider slider = cp5.addSlider(name)
    .setCaptionLabel(name)
    .setPosition(x, y)
    .setColorCaptionLabel(color(0,0,0))
    .setSize(myWidth, myHeight)
    .setRange(min, max)
    .setValue(value)
    .setDecimalPrecision(2);
    
  slider.getCaptionLabel().setSize(20);
    
  return slider;
}
