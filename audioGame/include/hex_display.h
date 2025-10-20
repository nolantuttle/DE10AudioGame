#ifndef HEX_DISPLAY_H
#define HEX_DISPLAY_H

// init and close hex displays
int init_hex0_hex3(void);
int init_hex4_hex5(void);
int close_hex0_hex3(void);
int close_hex4_hex5(void);

// write and clear hex displays
int hex_display_write(int display, int value);
int hex_display_clear(int display);
void hex_display_clear_all(void);

#endif
