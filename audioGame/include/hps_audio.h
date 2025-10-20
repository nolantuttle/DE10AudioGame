#ifndef HPS_AUDIO_H
#define HPS_AUDIO_H

#include <stdint.h>

int hps_audio_init(void);                                   // initialize audio interface (I2C), returns 0 on success
void hps_audio_write_sample(uint16_t left, uint16_t right); // send an audio sample to FPGA
int hps_audio_play_pattern(uint16_t *pattern, int length);  // play audio sequence
void hps_audio_close(void);                                 // close audio interface

#endif