//Importem llibreries
//Comunicacio serie
import processing.serial.*;
//Port serie valor
import java.awt.event.KeyEvent;
import java.io.IOException;

//Objecte serial
Serial myPort;

//Variables text o imatges
int xlogo=150;
int ylogo=100;
PFont orcFont;

// variables
String angle="";
String distance="";
String data="";

String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;

//Variable per menú inicial de processing
int manMenu;


//INICI VOID
void setup() {
     //Pintem el fons (resolució de pantalla) Nostre cas 1280*1024 o 1336*700 (no Pantalla)
     size (1366, 700);
     smooth();
     
     //Comença comunicació serie
     myPort = new Serial(this,"COM3", 9600);
     
     //Llegeix l'angle i distancia
     myPort.bufferUntil('.');
     orcFont = loadFont("OCRAStd-48.vlw");
     
     //Inicialitzem menu = 1
     manMenu = 1;
}


//INICI DRAW
void draw() {
  
  //Si el menu = 1 pintem missatge benvinguda i logo UOC
  if(manMenu ==1){
     
    /*imageMode(CENTER);
    PImage imagen=loadImage("logo.jpg");
    image(imagen,xlogo, ylogo, 150,150);*/
    fill(98,245,31);
    textFont(orcFont);
    //Blur pinta-linies
    noStroke();
    fill(0,4); 
    
    //Text inicial menú processing
    textAlign(CENTER);
    text("Pràctica Disseny Interfícies", 683,120); 
    //Click per començar
    text("Click para empezar", 683, 220);
    imageMode(CENTER);
    
    //Load imatge UOC centre inici menu
    PImage imagen=loadImage("logo.jpg");
    image(imagen, 683, 520, 220, 120);
    //textSize(50);
    
    //Si una tecla es pitjada, el menú passa a ser 2 i per tant continúa a la interfície
    if(keyPressed==true){
     manMenu=2; 
    }
  }else if(manMenu ==2){
    fill(98,245,31);
    textFont(orcFont);
    noStroke();
    fill(0,4); 
    rect(0, 0, width, height-height*0.065); 
    fill(98,245,31);
      
    //Titol del projecte amb logo UOC
    imageMode(CENTER);
    PImage imagen=loadImage("logo.jpg");
    image(imagen,xlogo, ylogo, 150,150);
    
    // Cridem a la resta de funcions per el programa
    dibuxaSonar(); 
    dibuixaLinies();
    dibuixaHitObjecte();
    dibuixaText();
    
    //Cridem STOP per reset variable manMenu
    }else{
      stop();
    }
  
}

//Llegim info del port serie
void serialEvent (Serial myPort) {
    //Info del port serie i escrivim a variable data
    data = myPort.readStringUntil('.');
    data = data.substring(0,data.length()-1);
    
    //Esbrnem "," i escrivim variable index1
    index1 = data.indexOf(",");
    //Variable posiio 0
    angle= data.substring(0, index1);
    //Variable posicio index1 fins al fianl    
    distance= data.substring(index1+1, data.length());
    
    
    //Passa de string a enter
    iAngle = int(angle);
    iDistance = int(distance);
}


//Funcio pintar sonar
void dibuxaSonar() {
    //https://processing.org/reference/pushMatrix_.html
    pushMatrix();
    
    //Mou a nova posicio
    translate(width/2,height-height*0.074);
    noFill();
    strokeWeight(2);
    stroke(98,245,31);
    
    // Dibuixa les línies tangents
    arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
    arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
    arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
    arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
    // Dibuixa les línies dels angles
    line(-width/2,0,width/2,0);
    line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
    line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
    line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
    line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
    line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
    line((-width/2)*cos(radians(30)),0,width/2,0);
    popMatrix();
}


//Dibuixa trobada objecte
void dibuixaHitObjecte() {
    pushMatrix();
    
    //Mou a nova posicio coordenades
    translate(width/2,height-height*0.074);
    strokeWeight(9);
    
    //color objecte
    stroke(255,10,10);
    pixsDistance = iDistance*((height-height*0.1666)*0.025); // covers the distance from the sensor from cm to pixels
    //Limitació del rang a 40 cm
      if(iDistance<40){
          // Dibuixa objectes segons el rang i angle
          line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
    }
    popMatrix();
}


//Dibuixa linies
void dibuixaLinies() {
    pushMatrix();
    strokeWeight(9);
    stroke(30,250,60);
    
    //Inici posició 0
    translate(width/2,height-height*0.074);
    //Dibuixa linia segons angle
    line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle)));
    popMatrix();
}


//Dibuix text
void dibuixaText() {
    pushMatrix();
   
    //Segons posició del objecte deim si esta dins o no
    if(iDistance>40) {
      noObject = "Fuera de rango";
    }
    else {
      noObject = "Dentro de rango";
    }
    
    fill(0,0,0);
    noStroke();
    rect(0, height-height*0.0648, width, height);
    fill(98,245,31);
    textSize(10);
    
    //Text programa
    text("10cm",width-width*0.3854,height-height*0.0833);
    text("20cm",width-width*0.281,height-height*0.0833);
    text("30cm",width-width*0.177,height-height*0.0833);
    text("40cm",width-width*0.0729,height-height*0.0833);
    textSize(20);
    text("Objecte: " + noObject, width-width*0.875, height-height*0.0277);
    text("Angulo: " + iAngle +" °", width-width*0.48, height-height*0.0277);
    text("Distancia: ", width-width*0.26, height-height*0.0277);
    
    //Segons la distancia in or out (linia 193) pintem el text de l'objecte si ho troba
    if(iDistance<40) {
        text("        " + iDistance +" cm", width-width*0.225, height-height*0.0277);
    }
    
    //Text dels angles a matriu
    textSize(15);
    fill(98,245,60);
    translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
    rotate(-radians(-60));
    text("30°",0,0);
    resetMatrix();
    translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
    rotate(-radians(-30));
    text("60°",0,0);
    resetMatrix();
    translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
    rotate(radians(0));
    text("90°",0,0);
    resetMatrix();
    translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
    rotate(radians(-30));
    text("120°",0,0);
    resetMatrix();
    translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
    rotate(radians(-60));
    text("150°",0,0);
    
    popMatrix(); 
}

//Funcio stop i resetejem variable menMenu per el menú inicial de processing
void stop(){
   manMenu = 1; 
}