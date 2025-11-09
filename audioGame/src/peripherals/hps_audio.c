#include "../include/hps_audio.h"
#include <stdio.h>

// stub method, initializes audio interface between HPS and FPGA
int hps_audio_init(void)
{
    printf("HPS audio initialized successfully.\n");
    return 0;
}

// stub method, writes a single audio sample to the audio interface
void hps_audio_write_sample(uint16_t left, uint16_t right)
{
    printf("Writing audio sample: Left: %u, Right: %u\n", left, right);
    // here the HPS would send the sample to the FPGA
}
// stub method, displays generated pattern 0-3 for tones that will be played
int hps_audio_play_pattern(uint16_t *pattern, int length)
{
    printf("Playing audio pattern. Sequence: ");
    for (int i = 0; i < length; i++)
    {
        printf("%u ", pattern[i]);
    }
    printf("\n");
    return 0;
}
// stub method, closing audio interface that was initialized
void hps_audio_close(void)
{
    printf("HPS audio interface closed.\n");
}