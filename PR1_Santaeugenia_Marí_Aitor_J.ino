// Llibrería per el Servo
//#Include 
//Servo serv;
#include <Servo.h>

//Servo
Servo servo;

//Variables per els pins del ultrasensor
const int trigPin = 10;
const int echoPin = 11;

//Variable per la posició inicial del servo
int pos = 0;

//Variables per duració i distància (v01)
long duration;
int distance;

//Objecte per controlar el servo
Servo myServo; 

//Inici SETUP
void setup() {
  //Output e input per els pins, v01
  //pinMode(trigPin, OUTPUT);
  //pinMode(echoPin, INPUT);
  Serial.begin(9600);

  myServo.write(0);
  
  //Pin del servo
  myServo.attach(9);
}


//Inici LOOP
void loop() {
//Si hi ha un input serial retornarà true
if (Serial.available()) {  
    //Llegeix caracter
    char ch = Serial.read(); 

    //Si es E
    if (ch == 'e') {
      // Limitem els graus.
      if (pos < 170) {
        pos += 1;
      }
    } else {
      // Limitem els graus
      if (pos > 10) {
        pos -= 1;
      }
    }

    distance = calculateDistance();
    // Movem servo
    servo.write(pos);
    // Delay
    delay(50);
    //delay(30);
    //delay(100);
  }
  
  /* V01 Automàtica
  // Rota el servo automàticament 
  for(int i=10;i<=170;i++){  
  myServo.write(i);
  delay(30);

  //Calcula la distancia
  distance = calculateDistance();

  //Grau del port
  Serial.print(i);
  //Indexacio per el port
  Serial.print(",");
  //Valor de la distancia
  Serial.print(distance); 
  Serial.print(".");
  }
  
  // Repeteix rotació
  for(int i=170;i>10;i--){  
    myServo.write(i);
    delay(30);
    distance = calculateDistance();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }*/
  
}



// Calcula la distancia del sensor
int calculateDistance(){ 

  //Sensor low 2 ms
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
  
  //Sensor hight 10 ms
  digitalWrite(trigPin, HIGH); 
  delayMicroseconds(10);
  
  digitalWrite(trigPin, LOW);

  //Llegeix valor sensor i retorna en ms
  duration = pulseIn(echoPin, HIGH); 

  //Velocitat del so 340 m/s en cm t=s/v = 10/0.034 = 294 ums
  distance= duration*0.034/2;
  return distance;
}
