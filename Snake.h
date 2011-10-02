/*
 * Snake - Abstraction of lights on HL1606 LED strips
 * Copyright (c) 2011, Patrick Schless
 */

#ifndef snake_h
#define snake_h

#include <HL1606grid.h>
#include "Pixel.h"

class Snake {
  public:
    Snake(HL1606grid *g);
    HL1606grid *grid;
    Pixel *pixels[64];
    uint8_t move(uint8_t direction);
    void moveTo(uint8_t row, uint8_t col);
    void growTo(uint8_t row, uint8_t col);
    bool moveUp();
    bool moveDown();
    bool moveRight();
    bool moveLeft();
    uint8_t size;

    void draw();

  private:
    void promoteBody();
    Pixel* allocatePixel(uint8_t row, uint8_t col);
};

#endif
