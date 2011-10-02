/*
 * Orchard - Collection of apples
 * Copyright (c) 2011, Patrick Schless
 */

#include "Orchard.h"

Orchard::Orchard(HL1606grid *g) {
  grid = g;
  size = 0;
}

void Orchard::grow() {
  uint8_t attempts = 0;
  while (attempts < 2) {
    uint8_t c = random(grid->cols);
    Serial.println(grid->rows, DEC);
    Serial.println(grid->cols, DEC);
    uint8_t r = random(grid->rows);
    if (grid->getLEDcolor(r, c) == BLACK) {
      apples[size] = Pixel(r, c);
      Serial.println(apples[size].row, DEC);
      Serial.println(apples[size].col, DEC);
      apples[size].marker = random(15) + 15;
      size++;
      Serial.println("final:");
      attempts = 3;
    } else {
      attempts += 1;
    }
  }
}

void Orchard::draw() {
  for (uint8_t i=0; i<size; i++) {
    if (apples[i].marker > 0) {
      if (--(apples[i].marker) == 0) {
        prune(i);
        i--;
      } else {
        grid->setLEDcolor(apples[i].row, apples[i].col, GREEN);
      }
    }
  }
}

void Orchard::prune(Pixel *p) {
  for (uint8_t i=0; i<size; i++) {
    if (apples[i].row == p->row && apples[i].col == p->col) {
      prune(i);
      break;
    }
  }
}

void Orchard::prune(uint8_t i) {
  grid->setLEDcolor(apples[i].row, apples[i].col, BLACK);
  for (uint8_t j=i; j<size; j++) {
    apples[j] = apples[j+1];
  }
  size--;
}

void Orchard::debug() {
  Serial.print("orchard (");
  Serial.print(size, DEC);
  Serial.print("): ");
  for (uint8_t i=0; i<size; i++) {
    Serial.print("(");
    Serial.print(apples[i].row, DEC);
    Serial.print(",");
    Serial.print(apples[i].col, DEC);
    Serial.print(",");
    Serial.print(apples[i].marker, DEC);
    Serial.print(") ");
  }
  Serial.println();
}
