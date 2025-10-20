#include <stdio.h>
#include <unistd.h>
#include "../include/hex_display.h"
#include "../include/hps_audio.h"
#include "../include/game_logic.h"

int init_buttons(void);
void cleanup_buttons(void);

int main()
{
    if (init_buttons() != 0)
    {
        printf("Button hardware initialization test failed.\n");
        return -1;
    }

    printf("Press a button (0-3)...\n");
    // Testing button press (debouncing process also inside buttons_wait_for_press)
    printf("Button %d pressed!\n", buttons_wait_for_press());

    cleanup_buttons();
    return 0;
}

int init_buttons(void)
{
    if (buttons_init() != 0)
    {
        return -1;
    }
    return 0;
}

void cleanup_buttons(void)
{
    // no specific cleanup needed for buttons in this implementation yet
}