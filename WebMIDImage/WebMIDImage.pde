import processing.video.*;
import themidibus.*;


ArrayList<String> reMaior = new ArrayList<String>();
ArrayList<String> miMaior = new ArrayList<String>();
 


//IMAGE
Capture cam;
int larg = 640, alt = 480;

//MIDI
MidiBus bus;

//variaveis de controle
int coluna = 0;

boolean simulation;

void setup() {
  size(640, 480);
  
  //ira listar todas as cameras disponiveis
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("Não existem cameras disponiveis!");
    exit();
  } else {
    println("Cameras disponiveis:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    //Escolhendo a camera desejada, por padrão a da posição 0, mas escolha de acordo com a preferencia
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }   
  
   //carregar o MIDI
  MidiBus.list();
  bus =  new MidiBus(this, "loopMIDI Port","loopMIDI Port");
  
  
  
  //foram criadas duas "escalas" musicais, a Re maior e a Mi maior
  
  //notas
  reMaior.add("D");
  reMaior.add("E");
  reMaior.add("F#");
  reMaior.add("G");
  reMaior.add("A");
  reMaior.add("B");
  reMaior.add("C#");
  
  miMaior.add("E");
  miMaior.add("F#");
  miMaior.add("G#");
  miMaior.add("A");
  miMaior.add("B");
  miMaior.add("C#");
  miMaior.add("D#");
  
  simulation = true;
}

void draw() {
  
  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  
  
  if(simulation){
    if(coluna < cam.width){
      float r = 0, g = 0, b = 0;
      for(int linha = 0; linha < cam.height; linha++){
          color c = cam.pixels[linha * cam.width + coluna];
          //calcula a média de cada coluna de pixels
          r += red(c);
          g += green(c);
          b += blue(c);
      }
      r /= cam.height;
      g /= cam.height;
      b /= cam.height;
      
      //agora normalizamos o valor, que em rgb pode ser entre 0 e 255 para valores pertencentes a escala musical, indo de 0 ate 127
      r = map(r, 0, 255, 0, 127);
      g = map(g, 0, 255, 0, 127);
      b = map(b, 0, 255, 0, 127);
           
      //definindo a intensidade com a qual "um pianista pressiona a tecla" por exemplo
      float br = constrain(brightness(color(r, g, b)) + random(80, 250), 130.0, 400.0);
        
      int vel = int(br);
      
      Note n1 = new Note(0, (int)r, vel);
      //println("R: " + n1);
      Note n2 = new Note(0, (int)g, vel);
      //println("G: " + n2);
      Note n3 = new Note(0, (int)b, vel);
      //println("B: " + n3);
      //println("\n\n=================================");
          
      
      boolean tocou = false;
     
        //só iremos tocar notas pertencentes a escala escolhida, neste caso reMaior
      ArrayList<String> notas = reMaior;
      
      if(contemNota(notas, n1.name())){
        bus.sendNoteOff(0, (int)r, vel); 
        bus.sendNoteOn(0, (int)r, vel);
        tocou = true;
      }
      if(contemNota(notas, n2.name())){
        bus.sendNoteOff(0, (int)g, vel);
        bus.sendNoteOn(0, (int)g, vel); 
        tocou = true;
      }
      if(contemNota(notas, n3.name())){
        bus.sendNoteOff(0, (int)b, vel);
        bus.sendNoteOn(0, (int)b, vel); 
        tocou = true;
      }
      
         
      if(tocou){
        delay(vel);
      }
          
      fill(255);
      rect(coluna, 0, 2, cam.height);  
      coluna++;
    }else{
      coluna = 0;
    }
  }
  
}

void mousePressed(){
   coluna = constrain(mouseX, 0, cam.width);
}

void keyPressed(){
  if(key == ' '){
   simulation = !simulation;
  }
}

boolean contemNota(ArrayList<String> notas, String nota){
  for(String n: notas){
    if(n == nota){
      return true;
    }
  }
  return false;
}