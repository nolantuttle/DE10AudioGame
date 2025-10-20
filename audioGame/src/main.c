#include <stdio.h>
#include <unistd.h>
#include "../include/hex_display.h"
#include "../include/hps_audio.h"
#include "../include/game_logic.h"

int init_hardware(void);
void cleanup_hardware(void);

int main()
{
    init_hardware();
    game_init();

    // Main game loop
    uint8_t sequence_length = 4; // This sets the length of the game
    // Our audio values we would generate would look something like these 4 values
    // uint16_t audio_pattern[4] = {440, 554, 659, 880}; Example audio frequencies

    uint16_t pattern[sequence_length];
    // Actual random generation of game sequence
    for (int i = 0; i < sequence_length; i++)
    {
        // For demonstration, we just print the sequence
        uint8_t next = game_generate_next();
        pattern[i] = next * 100; // Example translation to audio frequency
    }

    for (int i = 0; i < sequence_length; i++)
    {
        // Hex display will be used to show current sequence length
        hex_display_write(i % 6, i + 1); // Display numbers 1-6 for demo purposes

        // This line sets player answer to match the game sequence for testing
        uint8_t player_input = game_sequence_get(i);
        if (game_check_input(i, player_input))
        {
            printf("Correct input for index %d: %d\n", i, player_input);
        }
        else
        {
            printf("Incorrect input for index %d: %d (expected %d)\n", i, player_input, game_sequence_get(i));
        }
        usleep(500000); // Delay for half a second
    }

    game_reset();
    cleanup_hardware();
    return 0;
}

int init_hardware(void)
{
    // Initialize hex displays 0-3
    if (init_hex0_hex3() != 0)
    {
        printf("Failed to initialize hex displays 0-3.\n");
        return -1;
    }
    // Initialize hex displays 4-5
    if (init_hex4_hex5() != 0)
    {
        printf("Failed to initialize hex displays 4-5.\n");
        return -1;
    }
    // Audio initialization
    if (hps_audio_init() != 0)
    {
        printf("Failed to initialize HPS audio.\n");
        return -1;
    }
    if (buttons_init() != 0)
    {
        printf("Failed to initialize buttons.\n");
        return -1;
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
