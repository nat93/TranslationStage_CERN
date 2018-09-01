//--------------------------------------------------------------------------------//
//---------  Andrii Natochii  ------  CERN 2018  ---------------------------------//
//------------  e-mail: andrii.natochii@cern.ch  ---------------------------------//
//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//
//You have been allocated to the following IP address:
//IPv4[172.26.28.197]
//for interface LALARDUETH01 of device LALARDUETH01 connected on outlet 0887-R:2004/02.
//
//The following setting may also need to be configured your IPv4 network connection:
//Default gateway: 172.26.28.1
//Subnet mask: 255.255.255.0
//Broadcast address: 172.26.28.255 
//DNS servers: 137.138.16.5 and 137.138.17.5
//Time servers: 137.138.16.69, 137.138.17.69 and 137.138.18.69
//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//
//You have been allocated to the following IP address:
//IPv4[172.26.26.210]
//for interface LALARDUETH02 of device LALARDUETH02 connected on outlet 0887-R:2004/01.
//
//The following setting may also need to be configured your IPv4 network connection:
//Default gateway: 172.26.26.1
//Subnet mask: 255.255.255.0
//Broadcast address: 172.26.26.255 
//DNS servers: 137.138.16.5 and 137.138.17.5
//Time servers: 137.138.16.69, 137.138.17.69 and 137.138.18.69
//--------------------------------------------------------------------------------//
//--------------------------------------------------------------------------------//

#include <SPI.h>
#include <Ethernet2.h>
#include <AccelStepper.h>
#include <TimerOne.h>
//--------------------------------------------------------------------------------//
#define TIMER_US 100                                // 50mkS set timer duration in microseconds. 
volatile bool in_long_isr = false; 
boolean RunMotorStatus = false;                    // Boolean variable for running motors
                                                   // with period 2*TIMER_US
//--------------------------------------------------------------------------------//
//Ethernet Default Settings

byte mac[] = {0x90,0xA2,0xDA,0x10,0x76,0xFE};       // MAC address for the LALARDUETH01
IPAddress ip(172,26,28,197);                        // Default ip.

//byte mac[] = {0x90,0xA2,0xDA,0x0F,0x8B,0x0E};       // MAC address for the LALARDUETH02
//IPAddress ip(172,26,26,210);                        // Default ip.

EthernetServer server(80);                          // Default server.
EthernetClient client;                              // Object of EthernetClient class.
boolean reading = false;                            // Boolean variable.
String userString;                                  // Buffer of user command.
const int deselectSDpin = 4;                        // Pin fro deselecting SD card.
//--------------------------------------------------------------------------------//
//Switcher
const int SW11pin = A1;                             // Pin A1 of Arduino board - read switcher 11 (Motor1).
const int SW12pin = A2;                             // Pin A2 of Arduino board - read switcher 12 (Motor1).
const int SW21pin = A4;                             // Pin A4 of Arduino board - read switcher 21 (Motor2).
const int SW22pin = A3;                             // Pin A3 of Arduino board - read switcher 22 (Motor2).
const int SW31pin = A5;                             // Pin A5 of Arduino board - read switcher 31 (Motor3).
const int SW32pin = A0;                             // Pin A0 of Arduino board - read switcher 32 (Motor3).
int SW11st = 1;                                     // Status of the switcher 11.
int SW12st = 1;                                     // Status of the switcher 12.
int SW21st = 1;                                     // Status of the switcher 21.
int SW22st = 1;                                     // Status of the switcher 22.
int SW31st = 1;                                     // Status of the switcher 31.
int SW32st = 1;                                     // Status of the switcher 32.
                                                    // 1 - switcher is not pressed.
                                                    // 0 - switcher is pressed.
//--------------------------------------------------------------------------------//
//Motor1 Default Settings
AccelStepper stepper1(1,3,8);                       // First obj of AccelStepper class. A stepper motor controlled by a dedicated driver board.
                                                    // 3 - Pin 3 of Arduino board 
                                                    // - Step pin ;
                                                    // 8 - Pin 8 of Arduino board
                                                    // - Direction pin.
int long M1_speed = 0;                              // Steps per second.
int long M1_acc = 0;                                // Steps per second per second.
int long M1_dist = 0;                               // Distance in Steps.
int long M1_curpos = 0;                             // Current position in steps.
int long M1_targpos = 0;                            // Target position in steps.
boolean M1_ena = false;                             // Flag DISABLE.
boolean M1_move = false;                            // Flag MOVING.
//--------------------------------------------------------------------------------//
//Motor2 Default Settings
AccelStepper stepper2(1,5,9);                       // Second obj of AccelStepper class. A stepper motor controlled by a dedicated driver board.
                                                    // 5 - Pin 5 of Arduino board 
                                                    // - Step pin ;
                                                    // 9 - Pin 9 of Arduino board
                                                    // - Direction pin.
int long M2_speed = 0;                              // Steps per second.
int long M2_acc = 0;                                // Steps per second per second.
int long M2_dist = 0;                               // Distance in Steps.
int long M2_curpos = 0;                             // Current position in steps.
int long M2_targpos = 0;                            // Target position in steps.
boolean M2_ena = false;                             // Flag DISABLE.
boolean M2_move = false;                            // Flag MOVING.
//--------------------------------------------------------------------------------//
//Motor3 Default Settings
AccelStepper stepper3(1,7,6);                       // Second obj of AccelStepper class. A stepper motor controlled by a dedicated driver board.
                                                    // 7 - Pin 7 of Arduino board 
                                                    // - Step pin ;
                                                    // 6 - Pin 6 of Arduino board
                                                    // - Direction pin.
int long M3_speed = 0;                              // Steps per second.
int long M3_acc = 0;                                // Steps per second per second.
int long M3_dist = 0;                               // Distance in Steps.
int long M3_curpos = 0;                             // Current position in steps.
int long M3_targpos = 0;                            // Target position in steps.
boolean M3_ena = false;                             // Flag DISABLE.
boolean M3_move = false;                            // Flag MOVING.
//--------------------------------------------------------------------------------//
const int ENApin = 2;                              // Pin 2 - Enabling pin.
//--------------------------------------------------------------------------------//
// Setup function
void setup()
{
  //Serial.begin(9600);
  //--------------------------------------------------------------------------------//
  //Switcher
  pinMode(SW11pin, INPUT_PULLUP);
  pinMode(SW12pin, INPUT_PULLUP);
  pinMode(SW21pin, INPUT_PULLUP);
  pinMode(SW22pin, INPUT_PULLUP);
  pinMode(SW31pin, INPUT_PULLUP);
  pinMode(SW32pin, INPUT_PULLUP);
  //--------------------------------------------------------------------------------//
  //Ethernet Shield
  pinMode(deselectSDpin, OUTPUT);                    // Set like output pin 4 to deselect SD card.
  digitalWrite(deselectSDpin, HIGH);
  //--------------------------------------------------------------------------------//
  //Motors1 setup
  stepper1.setMinPulseWidth(20);                     // Set the minimum pulse width allowed
                                                     // by the stepper driver. The minimum 
                                                     // practical pulse width is approximately 
                                                     // 20 microseconds. Times less than 20 
                                                     // microseconds will usually result in 
                                                     // 20 microseconds or so.
  stepper1.setCurrentPosition(M1_curpos);            // Resets the current position of the 
                                                     // motor, so that wherever the motor 
                                                     // happens to be right now is considered 
                                                     // to be the new 0 position. 
                                                     // Useful for setting a zero position on 
                                                     // a stepper after an initial hardware 
                                                     // positioning move. Has the side effect 
                                                     // of setting the current motor speed to 0.
  //--------------------------------------------------------------------------------//
  //Motors2 setup
  stepper2.setMinPulseWidth(20);                     // Set the minimum pulse width allowed
                                                     // by the stepper driver. The minimum 
                                                     // practical pulse width is approximately 
                                                     // 20 microseconds. Times less than 20 
                                                     // microseconds will usually result in 
                                                     // 20 microseconds or so.
  stepper2.setCurrentPosition((-1)*M2_curpos);       // Resets the current position of the 
                                                     // motor, so that wherever the motor 
                                                     // happens to be right now is considered 
                                                     // to be the new 0 position. 
                                                     // Useful for setting a zero position on 
                                                     // a stepper after an initial hardware 
                                                     // positioning move. Has the side effect 
                                                     // of setting the current motor speed to 0.
  //--------------------------------------------------------------------------------//
  //Motors3 setup
  stepper3.setMinPulseWidth(20);                     // Set the minimum pulse width allowed
                                                     // by the stepper driver. The minimum 
                                                     // practical pulse width is approximately 
                                                     // 20 microseconds. Times less than 20 
                                                     // microseconds will usually result in 
                                                     // 20 microseconds or so.
  stepper3.setCurrentPosition(M3_curpos);            // Resets the current position of the 
                                                     // motor, so that wherever the motor 
                                                     // happens to be right now is considered 
                                                     // to be the new 0 position. 
                                                     // Useful for setting a zero position on 
                                                     // a stepper after an initial hardware 
                                                     // positioning move. Has the side effect 
                                                     // of setting the current motor speed to 0.                                                     
  //--------------------------------------------------------------------------------//
  pinMode(ENApin, OUTPUT);                          // Set ENApin as output. 
  digitalWrite(ENApin, LOW);                        // Disable motors.
  //--------------------------------------------------------------------------------//
  //Ethernet connection setup
  Ethernet.begin(mac, ip);                           // Initializes the ethernet library 
                                                     // and network settings.
  server.begin();                                    // Start listening for clients. 
  //--------------------------------------------------------------------------------//
  Timer1.initialize(TIMER_US);                       // Initialize timer1, and set a TIMER_US
                                                     // microseconds period.
  Timer1.attachInterrupt( timerIsr );                // Attaches timerIsr() as a timer overflow 
                                                     // interrupt.
  //--------------------------------------------------------------------------------//
}
//--------------------------------------------------------------------------------//
// Main loop
void loop()
{   
  //--------------------------------------------------------------------------------//
  userString = "";                                   // Clearning user command buffer.
  client = server.available();                       // If an incoming client connects, 
                                                     // there will be bytes available to 
                                                     // read.
  if (client)
  {
    CheckClient();                                   // Read and check client command
  }
  /*if(userString != "")
  {
    Serial.println(userString);
  }*/
  //--------------------------------------------------------------------------------//
}
//--------------------------------------------------------------------------------//
// Interrupt function
void timerIsr()
{
  //--------------------------------------------------------------------------------//
  if (in_long_isr)
  {
    return;
  }
  in_long_isr = true;
  interrupts();                                     // Start interrupt
  //--------------------------------------------------------------------------------//
  if(RunMotorStatus)
  {
    RunMotors();
  }
  RunMotorStatus = !RunMotorStatus;                // We use double period.
  //--------------------------------------------------------------------------------//
  // Check Switcher
  SW11st = 0;
  SW12st = 0;
  SW21st = 0;
  SW22st = 0;
  SW31st = 0;
  SW32st = 0;
  
  for(int i = 0; i < 10; i ++)
  {
    SW11st += abs(digitalRead(SW11pin));                   // Read input pin for switcher 11.
    SW12st += abs(digitalRead(SW12pin));                   // Read input pin for switcher 12.
    SW21st += abs(digitalRead(SW21pin));                   // Read input pin for switcher 21.
    SW22st += abs(digitalRead(SW22pin));                   // Read input pin for switcher 22.
    SW31st += abs(digitalRead(SW31pin));                   // Read input pin for switcher 31.
    SW32st += abs(digitalRead(SW32pin));                   // Read input pin for switcher 32.
  }
  
  M1_curpos = stepper1.currentPosition();
  M2_curpos = (-1)*stepper2.currentPosition();
  M3_curpos = stepper3.currentPosition();
  
  if(SW11st == 0 && M1_targpos < M1_curpos)
  {
    M1_move = false;
    M1_targpos = M1_curpos;
    stepper1.stop();
  }
  if(SW12st == 0 && M1_targpos > M1_curpos)
  {
    M1_move = false;
    M1_targpos = M1_curpos;
    stepper1.stop();  
  }
  if(SW21st == 0 && M2_targpos < M2_curpos)
  {
    M2_move = false;
    M2_targpos = M2_curpos;
    stepper2.stop(); 
  }
  if(SW22st == 0 && M2_targpos > M2_curpos)
  {
    M2_move = false;    
    M2_targpos = M2_curpos;
    stepper2.stop(); 
  }
  if(SW31st == 0 && M3_targpos < M3_curpos)
  {
    M3_move = false;
    M3_targpos = M3_curpos;
    stepper3.stop();
  }
  if(SW32st == 0 && M3_targpos > M3_curpos)
  {
    M3_move = false;
    M3_targpos = M3_curpos;
    stepper3.stop();  
  }
  //--------------------------------------------------------------------------------//
  noInterrupts();                                   // Stop interrupt
  in_long_isr = false;
  //--------------------------------------------------------------------------------//
}
//--------------------------------------------------------------------------------//
void RunMotors()
{
  //--------------------------------------------------------------------------------//
  // Motor1
  if(M1_move && M1_ena && M1_speed > 0)            // Check motor 1 flags
  {    
    stepper1.run();                                // Run motor 1
  }
  else
  {
    stepper1.stop();                               // Stop motor 1 as fast as possible: sets new target.
    M1_curpos = stepper1.currentPosition();
    stepper1.setCurrentPosition(M1_curpos);
  }  
  //--------------------------------------------------------------------------------//
  //Motor2
  if(M2_move && M2_ena && M2_speed > 0)            // Check motor 2 flags
  {
    stepper2.run();                                // Run motor 2
  }
  else
  {
    stepper2.stop();                               // Stop motor 2 as fast as possible: sets new target.
    M2_curpos = (-1)*stepper2.currentPosition();
    stepper2.setCurrentPosition((-1)*M2_curpos);
  } 
  //--------------------------------------------------------------------------------//
  // Motor3
  if(M3_move && M3_ena && M3_speed > 0)            // Check motor 3 flags
  {    
    stepper3.run();                                // Run motor 3
  }
  else
  {
    stepper3.stop();                               // Stop motor 3 as fast as possible: sets new target.
    M3_curpos = stepper3.currentPosition();
    stepper3.setCurrentPosition(M3_curpos);
  }  
}
//--------------------------------------------------------------------------------//
// Command checking function
void CheckClient()
{
  boolean b_st = false;
  boolean u_st = false;
  boolean q_st = false;
  //--------------------------------------------------------------------------------//
  while (client.connected())                       // While client connection is available 
  {    
    if(client.available())
    {  
      char c = client.read();                      // Read a byte of user (client) command
      if(reading && c == ' ') reading = false;
      if (c == '\n')  break;
      if(reading && c != '?') userString += c;
      if(c == '?') reading = true;
      if(reading && c == 'b')
      {
        b_st = true;
        break;
      }
      if(reading && c == 'u')
      {
        u_st = true;
        break;
      }
      if(reading && c == 'q')
      {
        q_st = true;
        break;
      }     
    }
  }
  client.flush();                                 // Discard any bytes that have been written 
                                                  // to the client but not yet read.                                               
  //--------------------------------------------------------------------------------//
  if(b_st)
  {
    server.println(stepper1.distanceToGo());      // Print to client the distance from the current 
                                                  // position of the motor 1 to the target position 
                                                  // in steps. Positive is clockwise from the current 
                                                  // position.
  }
  if(u_st)
  {
    server.println(stepper2.distanceToGo());      // Print to client the distance from the current 
                                                  // position of the motor 2 to the target position 
                                                  // in steps. Positive is clockwise from the current 
                                                  // position.
  }
  if(q_st)
  {
    server.println(stepper3.distanceToGo());      // Print to client the distance from the current 
                                                  // position of the motor 3 to the target position 
                                                  // in steps. Positive is clockwise from the current 
                                                  // position.
  }
  //--------------------------------------------------------------------------------//
  reading = false;
  int cLength = userString.length();              // Length of the user (client) command
  String firstFour = userString.substring(0,4);   // First four symbols of the command
  String firstFive = userString.substring(0,5);   // First five symbols of the command
  String firstSix = userString.substring(0,6);    // First six symbols of the command
  //-----------------------------------------------------------------------------------------------------------------------//
  // Switcher status
  if(userString == "sw11")
  {
    server.println(SW11st);
  }
  if(userString == "sw12")
  {
    server.println(SW12st);
  }
  if(userString == "sw21")
  {
    server.println(SW21st);
  }
  if(userString == "sw22")
  {
    server.println(SW22st);
  }
  if(userString == "sw31")
  {
    server.println(SW31st);
  }
  if(userString == "sw32")
  {
    server.println(SW32st);
  }
  //--------------------------------------------------------------------------------//
  // Enabling
  if(userString == "eall")
  {
    digitalWrite(ENApin, HIGH);
    delayMicroseconds(10);
    M1_ena = true;
    M2_ena = true;
    M3_ena = true;
  }
  //--------------------------------------------------------------------------------//
  // Disabling
  if(userString == "deall")
  {
    digitalWrite(ENApin, LOW);
    delayMicroseconds(10);
    
    M1_ena = false;
    M1_move = false;
    
    M2_ena = false;
    M2_move = false;
    
    M3_ena = false;
    M3_move = false;
  }
  //--------------------------------------------------------------------------------//
  // Speed
  if(firstFour == "m1sp")                         // Motor 1
  {
    String str = userString.substring(4,cLength); // Read speed value from user (client).
    M1_speed = atol(str.c_str());                 // Convert string to integer.
  }
  if(firstFour == "m2sp")                         // Motor 2
  {
    String str = userString.substring(4,cLength); // Read speed value from user (client).
    M2_speed = atol(str.c_str());                 // Convert string to integer.
  }
  if(firstFour == "m3sp")                         // Motor 3
  {
    String str = userString.substring(4,cLength); // Read speed value from user (client).
    M3_speed = atol(str.c_str());                 // Convert string to integer.
  }
  //--------------------------------------------------------------------------------//  
  // Current position
  if(firstFour == "m1cp")                         // Motor 1
  {
    String str = userString.substring(4,cLength); // Read current position value for motor 1
                                                  // from user (client).
    M1_curpos = atol(str.c_str());
    stepper1.setCurrentPosition(M1_curpos);
  }
  if(firstFour == "m2cp")                         // Motor 2
  {
    String str = userString.substring(5,cLength); // Read current position value for motor 2
                                                  // from user (client).
    M2_curpos = atol(str.c_str());
    stepper2.setCurrentPosition((-1)*M2_curpos);
  }
  if(firstFour == "m3cp")                         // Motor 3
  {
    String str = userString.substring(4,cLength); // Read current position value for motor 3
                                                  // from user (client).
    M3_curpos = atol(str.c_str());
    stepper3.setCurrentPosition(M3_curpos);
  }
  //--------------------------------------------------------------------------------//    
  // Acceleration
  if(firstFour == "m1ac")                         // Motor 1
  {
    String str = userString.substring(4,cLength); // Read acceleration value for motor 2
                                                  // from user (client).
    M1_acc = atol(str.c_str());
  }
  if(firstFour == "m2ac")                         // Motor 2
  {
    String str = userString.substring(4,cLength); // Read acceleration value for motor 2
                                                  // from user (client).
    M2_acc = atol(str.c_str());
  }
  if(firstFour == "m3ac")                         // Motor 3
  {
    String str = userString.substring(4,cLength); // Read acceleration value for motor 3
                                                  // from user (client).
    M3_acc = atol(str.c_str());
  }
  //--------------------------------------------------------------------------------//    
  // Run motors
  if(firstSix == "m1move")                        // Motor 1
  {
    M1_move = true;
    String str = userString.substring(6,cLength); // Read target postiion.      
    stepper1.setMaxSpeed(M1_speed);               // Set the maximum permitted speed. 
                                                  // The run() function will accelerate 
                                                  // up to the M1_speed set by this function.
    stepper1.setAcceleration(M1_acc);             // Set acceleration.
    M1_targpos = atol(str.c_str());
    stepper1.moveTo(M1_targpos);                  // Set the target position. The run() 
                                                  // function will try to move the motor 
                                                  // (at most one step per call) from the 
                                                  // current position to the target position
                                                  // set by the most recent call to this function.
  }
  if(firstSix == "m2move")                        // Motor 2
  {
    M2_move = true;
    String str = userString.substring(6,cLength); // Read target postiion       
    stepper2.setMaxSpeed(M2_speed);               // Set the maximum permitted speed. 
                                                  // The run() function will accelerate 
                                                  // up to the M2_speed set by this function.
    stepper2.setAcceleration(M2_acc);             // Set acceleration.
    M2_targpos = atol(str.c_str());
    stepper2.moveTo((-1)*M2_targpos);             // Set the target position. The run() 
                                                  // function will try to move the motor 
                                                  // (at most one step per call) from the 
                                                  // current position to the target position
                                                  // set by the most recent call to this function.
  }
  if(firstSix == "m3move")                        // Motor 3
  {
    M3_move = true;
    String str = userString.substring(6,cLength); // Read target postiion.      
    stepper3.setMaxSpeed(M3_speed);               // Set the maximum permitted speed. 
                                                  // The run() function will accelerate 
                                                  // up to the M3_speed set by this function.
    stepper3.setAcceleration(M3_acc);             // Set acceleration.
    M3_targpos = atol(str.c_str());
    stepper3.moveTo(M3_targpos);                  // Set the target position. The run() 
                                                  // function will try to move the motor 
                                                  // (at most one step per call) from the 
                                                  // current position to the target position
                                                  // set by the most recent call to this function.
  }
  //--------------------------------------------------------------------------------//
  // Stop motors
  if(userString == "m1stop")                      // Motor 1
  {
    M1_move = false;
  }
  if(userString == "m2stop")                      // Motor 2
  {
    M2_move = false;
  }
  if(userString == "m3stop")                      // Motor 3
  {
    M3_move = false;
  }
  //--------------------------------------------------------------------------------//
  // Get current position
  if(userString == "gcp1")
  {
    client.flush();
    server.println(stepper1.currentPosition());    // Send to user current position of the motor 1
  }
  if(userString == "gcp2")
  {
    client.flush();
    server.println((-1)*stepper2.currentPosition());    // Send to user current position of the motor 2
  }
  if(userString == "gcp3")
  {
    client.flush();
    server.println(stepper3.currentPosition());    // Send to user current position of the motor 3
  }
  //--------------------------------------------------------------------------------//
  // Get enabling status
  if(userString == "eallst")
  {
    client.flush();
    server.println(digitalRead(ENApin));
  }
  //--------------------------------------------------------------------------------//
  if(userString == "mst")                          // Print status of the system.
  {
    client.flush();
    String statusString = "<< MOTOR 1: speed = ";
    statusString += M1_speed; 
    statusString += " steps per second | acceleration = ";
    statusString += M1_acc;
    statusString += " steps per second per second | status of the moving = ";
    statusString += M1_move;
    statusString += " | status of the enabling = ";
    statusString += M1_ena;
    statusString += " | current position = ";
    statusString += stepper1.currentPosition();
    statusString += " steps | SW11[";
    statusString += SW11st;
    statusString += "] | SW12[";
    statusString += SW12st;
    statusString += "] >>";
    statusString += " || << MOTOR 2: speed = ";
    statusString += M2_speed; 
    statusString += " steps per second | acceleration = ";
    statusString += M2_acc;
    statusString += " steps per second per second | status of the moving = ";
    statusString += M2_move;
    statusString += " | status of the enabling = ";
    statusString += M2_ena;
    statusString += " | current position = ";
    statusString += (-1)*stepper2.currentPosition();
    statusString += " steps | SW21[";
    statusString += SW21st;
    statusString += "] | SW22[";
    statusString += SW22st;
    statusString += "] >>";
    statusString += " || << MOTOR 3: speed = ";
    statusString += M3_speed; 
    statusString += " steps per second | acceleration = ";
    statusString += M3_acc;
    statusString += " steps per second per second | status of the moving = ";
    statusString += M3_move;
    statusString += " | status of the enabling = ";
    statusString += M3_ena;
    statusString += " | current position = ";
    statusString += stepper3.currentPosition();
    statusString += " steps | SW31[";
    statusString += SW31st;
    statusString += "] | SW32[";
    statusString += SW32st;
    statusString += "] >>";
    server.println(statusString);
  }
}
//--------------------------------------------------------------------------------//
