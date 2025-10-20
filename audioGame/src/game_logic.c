#include "../include/game_logic.h"
#include <stdio.h>
#include <stdlib.h> // for rand()
#include <time.h>   // for seeding rand()

#define MAX_SEQUENCE 100

static uint8_t sequence[MAX_SEQUENCE];
static uint8_t current_sequence_length = 0;

// stub method to initialize the game
void game_init(void)
{
    current_sequence_length = 0;
    // seed RNG for sequence generation
    srand(time(NULL));
    printf("Game initialized!\n");
}

// generate the next element in the sequence (0-3)
uint8_t game_generate_next(void)
{
    if (current_sequence_length >= MAX_SEQUENCE)
        return 0;                               // return 0 if max length reached
    uint8_t next = rand() % 4;                  // random number between 0 and 3
    sequence[current_sequence_length++] = next; // add to sequence
    printf("Next: %u\n", next);
    return next; // return the generated value
}

// check if player input matches sequence at index
uint8_t game_check_input(uint8_t index, uint8_t player_input)
{
    if (index >= current_sequence_length) // if index out of bounds
        return 0;
    return (player_input == sequence[index]); // return 1 if match
}
uint8_t game_get_sequence_length(void)
{
    return current_sequence_length;
}

// get a specific element from the sequence
uint8_t game_sequence_get(uint8_t index)
{
    if (index >= current_sequence_length)
        return 0xFF; // error hex value
    return sequence[index];
}

// stub method to reset the game
void game_reset(void)
{
    current_sequence_length = 0;
    printf("Game sequence reset!\n");
}