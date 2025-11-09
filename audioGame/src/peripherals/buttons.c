#include "../include/buttons.h"
#include "../lib/address_map_arm.h" // for button base address
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

#define BUTTON_MASK 0xF // in binary, 0xF is '0000 1111', so this mask is used to AND gate the 4 bits for the 4 buttons

volatile uint32_t *button_ptr = (volatile uint32_t *)KEY_BASE;

// stub method to initialize the button hardware
int buttons_init(void)
{
    // buttons should be just memory-mapped i/o to in fpga
    printf("Buttons successfully initialized");
    return 0;
}

// read the current state of all buttons as a 4-bit mask
uint8_t buttons_read(void)
{
    return (*button_ptr) & BUTTON_MASK; // return only the lower 4 bits representing the buttons
}

// stub method to wait for the user to press a button and return which button was pressed (0-3)
uint8_t buttons_wait_for_press(void)
{
    uint8_t button_state;

    printf("Waiting for user to press a button...\n");
    while (1)
    {
        button_state = buttons_read();
        if (button_state != 0)
        {
            // loop through all 4 buttons to see which one was pressed
            for (int i = 0; i < 4; i++)
            {
                // here, we are bit shifting 1 to the left i times so we can use it as a mask.
                // this way, we only check the digit we want to check, for example for button 2 we shift so we can AND gate with 0010
                if (button_state & (1 << i))
                {
                    if (button_debounce(i))
                    {
                        printf("Button %d pressed.\n", i + 1);
                        return i; // return button index (0-3)
                    }
                }
            }
        }
    }
}

// stub method for debounce logic for a single button
uint8_t button_debounce(uint8_t button_index)
{
    // the way this debounce should work is that if a press is detected, we wait a short period and check again
    usleep(50000); // wait for 50 ms
    // if the button is still pressed, we know that it is a valid press
    uint8_t button_state = buttons_read();
    // we are doing a similar bit masking here, we shift left by the button index to get the right button
    // we AND gate with the button state to see if it is still pressed
    if (button_state & (1 << button_index))
    {
        return 1; // button is confirmed pressed
    }
    return 0; // button is not pressed
}