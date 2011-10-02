/*
Snake Attack!

Copyright Patrick Schless, 2011
*/


// HL1606strip is an adaptation of LEDstrip from  http://code.google.com/p/ledstrip/
#include "Snake.h"
#include "Orchard.h"
#include <Wire.h>
#include "nunchuck_funcs.h"
#include <HL1606grid.h>
#include <Pixel.h>
#include <HL1606strip.h>

// use -any- 3 pins!
#define STRIP_D 4
#define STRIP_C 3
#define STRIP_L 2
#define RIGHT_PADDLE 8
#define LEFT_PADDLE 9
#define NO_INPUT 0

// Pin S is not really used in this demo since it doesnt use the built in PWM fade
// The last argument is the number of LEDs in the strip. Each chip has 2 LEDs, and the number
// of chips/LEDs per meter varies so make sure to count them! if you have the wrong number
// the strip will act a little strangely, with the end pixels not showing up the way you like
HL1606strip strip = HL1606strip(STRIP_D, STRIP_L, STRIP_C, 64);
HL1606grid grid = HL1606grid(&strip);
Orchard orchard = Orchard(&grid);

uint8_t lastInputState;
uint8_t lastInputTime;

uint8_t blockPosition = 0;
int joystick_x;

void setup(void) {
  Serial.begin(9600);
  randomSeed(analogRead(0));

  nunchuck_setpowerpins();
  nunchuck_init();

  lastInputState = NO_INPUT;
  lastInputTime = 0;
}

void loop() {
  snakeGrid();
  //blocksAcross();
  //snake(3, 20);
}

uint8_t getInput() {
  uint8_t input;

  nunchuck_get_data();
  joystick_x = nunchuck_joyx(); 
Serial.print("joyx: ");
Serial.println(joystick_x, DEC);
  if (joystick_x > 200) {
    input = RIGHT_PADDLE;
  } else if (joystick_x < 50) {
    input = LEFT_PADDLE;
  } else {
    input = NO_INPUT;
  }

  if (input != lastInputState) {
    lastInputState = input;
    return input;
  } else {
    return NO_INPUT;
  }
}

void snakeGrid() {
  uint8_t row = 0;
  uint8_t direction = 0;
  uint8_t input;
  uint8_t duration = 100;

  Pixel *apples[3];

  Snake snake = Snake(&grid);

  while (true) {
    input = getInput();
    if (input == RIGHT_PADDLE) direction = (direction + 1) % 4;
    if (input == LEFT_PADDLE) direction = (direction + 3) % 4;

    for (uint8_t snakeLED=0; snakeLED<snake.size; snakeLED++) {
      Serial.print("(");
      Serial.print(snake.pixels[snakeLED]->row, 10);
      Serial.print(",");
      Serial.print(snake.pixels[snakeLED]->col, 10);
      Serial.println(")");
      grid.setLEDcolor(snake.pixels[snakeLED]->row, snake.pixels[snakeLED]->col, RED);
    }

    if (orchard.size < 3 && random(15) == 0) {
      orchard.grow();
    }

    orchard.draw();

    grid.writeGrid();
    delay(duration);
    uint8_t movement = snake.move(direction);
    if (movement == 0) {
      grid.fill(BLUE);
      grid.writeGrid();
      delay(1000);
      grid.clear();
      orchard = Orchard(&grid);
      snake = Snake(&grid);
      direction = 0;
      duration = 100;
    }

    if (movement == 1) {
      orchard.prune(snake.pixels[0]);
      duration += 1;
      if (duration > 250) duration = 250;
    }

    row = (row + 1) % 8;
    Serial.println();
  }
}

