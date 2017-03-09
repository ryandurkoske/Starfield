//your code here
ArrayList<Particle> particles = new ArrayList<Particle>();
int screenX = 750;
int screenY = 750;
float skyAngle = 0;
float satelliteCoolDown = 0;
void setup()
{
  size(screenX,screenY);
  background(20);
  noStroke();
  //particles.add(new NormalParticle());
  generateStars();
  generateInnerGalacticGas();
}
void generateStars(){
  int maxMag = (int)Math.round(Math.sqrt(screenX*screenX + screenY*screenY));
  for(int i = 0; i < 30000; i++){
    //double angle = Math.random() * 2 * Math.PI;
    
    //double mag = Math.random() * maxMag;
    //particles.add(new OddballParticle(cos((float)angle)*mag,sin((float)angle)*mag));
    //rectangle option
    double x = Math.random() * maxMag * 2 - maxMag;
    double y = Math.random() * maxMag * 2 - maxMag;
    particles.add(new OddballParticle(x,y));
  }
  
}
void generateInnerGalacticGas(){
  double rndTransX = Math.random() * 500;
  double rndTransY = Math.random() * 500;
  double rndRot = Math.random() *2 * Math.PI;
  for(float i = 0; i < 600; i++){
    double x = Math.random() * 1000;
    double xDist = Math.abs(1000/2 - x); 
    double maxY = Math.pow(500-(xDist/2),0.7);
    double y = Math.random() *maxY * 2 - maxY;
    double yDist = maxY - Math.abs(y);
    color c = color(75,0,75,30);
    if(yDist < 50 && Math.random() < 0.4){
      c = color(255,240,10,Math.round(Math.random()*10+10));
    }
    //transformation time
    double x_ = x + rndTransX;
    double y_ = y + rndTransY;
    double deltaX = x_ - rndTransX;
    double deltaY = y_ - rndTransY;
    double mag = Math.sqrt(Math.pow(deltaX,2) + Math.pow(deltaY,2));
    deltaY/=mag;
    float theta = asin((float)deltaY);
    theta += rndRot;
    double xx = cos(theta)*mag+rndTransX;
    double yy = sin(theta)*mag+rndTransY;
    //transorfming over
    particles.add(new JumboParticle(xx,yy,c)); //add to a different list, translate and rotate then add back to main list
  }
}
void draw()
{
  fill(20);
  rect(0,0,screenX,screenY);
  skyAngle-=0.001;
  for(int i = 0; i < particles.size(); i++){
    noStroke();
    Particle p = particles.get(i);
    p.tick();
    p.render();
  }
  noStroke();
  if(Math.random() < satelliteCoolDown){
    particles.add(new NormalParticle());
    satelliteCoolDown=0;
  }
  satelliteCoolDown+=0.0001;
  drawScene();
}
void drawScene(){  
  fill(30,50,40);
  ellipse(300,785,500,160);
  
  fill(40,70,50);
  ellipse(125,800,500,160);
  
  fill(40,80,50);
  ellipse(900,775,1500,200);
}
class NormalParticle implements Particle
{
  float speed;
  ArrayList<Double> x = new ArrayList<Double>();
  ArrayList<Double> y = new ArrayList<Double>();
  
  double angle;
  public NormalParticle(){
    double rnd = Math.random();
    if(rnd < 1){
      this.x.add(-10D);
      this.y.add((Math.random() * (screenY - 500)) + 300);
      this.angle = -0.4 * Math.random();
      this.speed = 100;//(float)(40 * Math.random() + 40);
    }else{
      //too bad
    }
  }
  public void tick(){
    int dist = (int)Math.round(screenX/2 - this.x.get(0));
    double ratio = dist / (screenX/2);
    this.angle += 0.01;
    float x = cos((float)this.angle)*this.speed;
    float y = sin((float)this.angle)*this.speed;
    this.x.add(0,this.x.get(0)+x);
    this.y.add(0,this.y.get(0)+y);
    
    if(this.x.size() > 4){
      this.x.remove(4);
      //println(this.x.remove(10));
    }
    if(this.y.size() > 4){
      this.y.remove(4);
    }
  }
  public void render(){
    strokeWeight(3);
    stroke(255,246,72,(int)Math.round(60 * Math.random() + 20));
    for(int i = 0; i < this.x.size()-2; i++){
      line((float)(double)this.x.get(i),(float)(double)this.y.get(i),(float)(double)this.x.get(i+1),(float)(double)this.y.get(i+1));
    }
  }
}
interface Particle
{
  public void tick();
  public void render();
}
class OddballParticle implements Particle//uses an interface
{
  double x;
  double y;
  color c = color(255);
  float size;
  public OddballParticle(double x, double y){
    this.x = x;
    this.y = y;
    this.size = (float)Math.random() * 2.5;
    float colorChance = (float)Math.random();
    if(colorChance < 0.2){
      //this.c = color((int)Math.round(Math.random() * 30 + 150),30,(int)Math.round(Math.random() * 30 + 150));
      this.c = color((int)Math.round(Math.random() * 30 + 150),100,(int)Math.round(Math.random() * 30 + 150));
    }else if(colorChance < 0.4){
      //this.c = color(100,100,(int)Math.round(Math.random() *50 + 200));
      this.c = color((int)(255 - Math.round(Math.random()*100+70)),(int)(255 - Math.round(Math.random()*100+70)),255);
    }
  }
  public void tick(){
    
  }
  public void render(){
    pushMatrix();
    translate(-200,200);
    //translate(100,100);
    rotate(skyAngle);
    fill(this.c);
    rect((int)this.x,(int)this.y,this.size,this.size);
    popMatrix();
  }
}
class JumboParticle extends OddballParticle//uses inheritance
{
  public JumboParticle(double x, double y, color c){
    super(x,y);
    this.c = c;
    this.size = (int)Math.round(Math.random() * 50 + 10);
  }
  public void render(){
    pushMatrix();
    translate(-200,200);
    //translate(100,100);
    rotate(skyAngle);
    fill(this.c);
    ellipse((float)this.x,(float)this.y,this.size,this.size);
    popMatrix();
  }
}

