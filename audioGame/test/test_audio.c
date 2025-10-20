#include <stdio.h>
#include <unistd.h>
#include "../include/hex_display.h"
#include "../include/hps_audio.h"
#include "../include/game_logic.h"

int init_audio(void);
void cleanup_hardware(void);

int main(void)
{
    if (init_audio() != 0)
    {
        printf("Audio initialization failed.\n");
        return -1;
    }
    game_init();

    // testing hps_audio_write_sample for audio output
    printf("Testing tone generation...\n");
    hps_audio_write_sample(440, 500); // A4 note for 500 ms
    sleep(1);                         // wait for a second to simulate audio playback
    hps_audio_write_sample(0, 0);     // silence
    sleep(1);                         // wait for a second
    hps_audio_write_sample(523, 600); // C5 note for 600 ms
    printf("Tone generation test complete.\n");

    game_reset();
    cleanup_hardware();
    return 0;
}

// stub function to initialize audio
int init_audio(void)
{
    if (hps_audio_init() != 0)
    {
        return -1;
    }
    return 0;
}

void cleanup_hardware(void)
{
    hps_audio_close();
}