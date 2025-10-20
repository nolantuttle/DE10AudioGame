#ifndef GAME_LOGIC_H
#define GAME_LOGIC_H

#include <stdint.h>

// initialize the game state (score = 0, clear sequence)
void game_init(void);

// generate a random next element in the sequence (four possible tones)
uint8_t game_generate_next(void);

// check if the players input matches the sequence at a specific index
uint8_t game_check_input(uint8_t index, uint8_t player_input);

// get the current sequence length
uint8_t game_get_sequence_length(void);

// get the value at an index in the current sequence
uint8_t game_sequence_get(uint8_t index);

// reset the sequence and score (game over or restart)
void game_reset(void);

#endif