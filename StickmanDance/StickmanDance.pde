import themidibus.*;

//MIDI
MidiBus bus;

boolean primeiro = true;
boolean dancaVitoria = false;
int estado = 0;

float x, y, x2, y2;
float angle1 = 0.0;
float angle2 = 0.0;
float segLength = 40;

int cont = 0;
float cr = 255.0;
float cg = 255.0;
float cb = 255.0;

void setup(){
  size(640, 360);
  strokeWeight(20);
  stroke(255, 160);
  
  x = width * 0.5;
  y = height * 0.5;
  
  
  //carregar o MIDI
  //listando as portas disponiveis
  MidiBus.list();
  //esta porta em especifico foi criada utilizando o softwrae LoopMIDI
  String PortaEntrada = "loopMIDI Port";
  String PortaSaida = "loopMIDI Port";
  bus =  new MidiBus(this, PortaEntrada, PortaSaida);
}


void draw(){
  
  background(0);
 
   //cabeca
  pushMatrix();
    movimento(2, 160, 60, 50, 0); 
  popMatrix();
  
  //tronco
  pushMatrix();
    if(cont == 3){
      cont = 0;
    }
    fill(color(cr, cg, cb));
    movimento(1, x, y - 25, segLength + 100, PI/2); 
  popMatrix();
    
  //bracos
  pushMatrix();
    movimento(1, x, y + 10, segLength, angle1); 
    movimento(1, segLength, 0, segLength, angle2);
  popMatrix();

  pushMatrix();
   movimento(1, x, y + 10, -segLength, -angle1); 
   movimento(1, -segLength, 0, -segLength, -angle2);
  popMatrix();
  
  //Pernas
  pushMatrix();
    movimento(1, x, y + 125, -segLength, -45); 
  popMatrix();
  
  pushMatrix();
    movimento(1, x, y + 125, segLength, 45); 
  popMatrix();

  
  if(dancaVitoria){
    if(estado == 0){
        angle1 = 0.0;
        angle2 = -PI/4;
        delay(200);
        estado = 1;
    }
    else if(estado == 1){
        angle1 = -PI/4;
        angle2 = PI/4;
        delay(200);
        estado = 2;
    }
    else if(estado == 2){
        angle2 = PI/2;
        delay(200);
        estado = 0;
    }
  } 
  
  
}

void movimento(int tip, float x, float y, float dist, float a) {
  translate(x, y);
  rotate(a);
  if(tip == 1){
    //linha
    line(0, 0, dist, 0);
  }else if(tip == 2){
    //circle
    ellipse(x, y, dist, dist);
  }
}

void noteOn(int channel, int pitch, int velocity) {
  float norm = map(pitch, 0, 127, -PI/2, PI/2);
  if(primeiro){
    angle1 = norm;
  }else{
    angle2 = norm;
  }  
  primeiro = !primeiro;  
  
  if(cont == 0){
    cr = map(pitch, 0, 127, 0, 255);
    cont = 1;
  }
  else if(cont == 1){
    cg = map(pitch, 0, 127, 0, 255);
    cont = 2;
  }
  else if(cont == 2){
    cb = map(pitch, 0, 127, 0, 255);
    cont = 3;
  }
} 

void keyPressed(){
  if(key == 'd'){
    dancaVitoria = !dancaVitoria;
  }
}