#include <stdio.h>
#include <unistd.h>
#include "../include/hex_display.h"
#include "../include/hps_audio.h"
#include "../include/game_logic.h"
#include "../include/buttons.h"

int init_hardware(void);
void cleanup_hardware(void);

int main()
{
    while (1)
    {
        *(JP1_ptr + 0) = 0x1; // start tone A
        msleep(100);          // tone duration
        *(JP1_ptr + 0) = 0x0; // stop tone
        msleep(100);
    }
    return 0;
}

void cleanup_hardware(void)
{
    hex_display_clear_all();
    close_hex0_hex3();
    close_hex4_hex5();
    hps_audio_close();
}
