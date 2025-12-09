#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "../lib/address_map_arm.h"

volatile uint32_t *JP1_ptr;

int main()
{
    int fd;
    void *lw_virtual;

    // Open /dev/mem
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1)
    {
        perror("open /dev/mem");
        return EXIT_FAILURE;
    }

    // Map lightweight bridge
    lw_virtual = mmap(NULL, LW_BRIDGE_SPAN, PROT_READ | PROT_WRITE, MAP_SHARED, fd, LW_BRIDGE_BASE);
    if (lw_virtual == MAP_FAILED)
    {
        perror("mmap");
        close(fd);
        return EXIT_FAILURE;
    }

    JP1_ptr = (volatile uint32_t *)(lw_virtual + JP1_BASE);

    *(JP1_ptr + 1) = 0x0; // All pins JP1[3:0] are inputs

    uint32_t prev_state = 0;

    printf("Starting blocking read loop...\n");

    /*while (1)
    {
        uint32_t buttons = *JP1_ptr & 0xF; // read lower 4 GPIO bits

        // Detect rising edge (0 -> 1)
        uint32_t pressed = (~prev_state) & buttons;
        if (pressed)
        {
            if (pressed & 0x1)
                printf("Button 0 pressed\n");
            if (pressed & 0x2)
                printf("Button 1 pressed\n");
            if (pressed & 0x4)
                printf("Button 2 pressed\n");
            if (pressed & 0x8)
                printf("Button 3 pressed\n");

            // TODO: Send button press to your memory game logic here
        }

        prev_state = buttons;

        usleep(10000); // ~10ms polling for debounce
    }*/
    for (int i = 0; i < 10; i++)
    {
        printf("JP1: 0x%X\n", *JP1_ptr);
        usleep(100000);
    }

    munmap((void *)lw_virtual, LW_BRIDGE_SPAN);
    close(fd);
    return 0;
}
