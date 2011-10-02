/*
 * Orchard - Collection of apples
 * Copyright (c) 2011, Patrick Schless
 */

#ifndef orchard_h
#define orchard_h

#include "Pixel.h"
#include <HL1606grid.h>

class Orchard {
  public:
    Orchard(HL1606grid *g);
    HL1606grid *grid;
    Pixel apples[3];
    uint8_t size;

    void grow();
    void draw();
    void debug();
    void prune(uint8_t i);
    void prune(Pixel *p);
};

#endif
