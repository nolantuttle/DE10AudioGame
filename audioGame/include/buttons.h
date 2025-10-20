#ifndef BUTTONS_H
#define BUTTONS_H

#include <stdint.h>

// initialize the button hardware
int buttons_init(void);

// read the current state of all buttons as a 4-bit mask
// bit 0 = button 1, bit 1 = button 2, etc.
uint8_t buttons_read(void);

// wait for the user to press a button and return which button was pressed (0-3)
uint8_t buttons_wait_for_press(void);

// debounce logic for a single button
uint8_t button_debounce(uint8_t button_index);

#endif