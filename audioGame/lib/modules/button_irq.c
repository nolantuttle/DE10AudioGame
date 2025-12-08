#include <linux/types.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/interrupt.h>
#include <asm/io.h>
#include "../address_map_arm.h"
#include "../interrupt_ID.h"

MODULE_LICENSE("MIT");
MODULE_AUTHOR("Nolan Tuttle");
MODULE_DESCRIPTION("Button Interrupt Handler for DE10-Standard FPGA Audio Game");

void *LW_virtual;       // Lightweight bridge base address
volatile int *LEDR_ptr; // virtual address for the LEDR port
volatile int *KEY_ptr;  // virtual address for the KEY port
volatile int *JP1_ptr;  // virtual address for the JP1 port

irq_handler_t irq_handler(int irq, void *dev_id, struct pt_regs *regs)
{
    *LEDR_ptr = *LEDR_ptr + 1;
    // Clear the edgecapture register (clears current interrupt)
    *(KEY_ptr + 3) = 0xF;

    return (irq_handler_t)IRQ_HANDLED;
}

static int __init initialize_pushbutton_handler(void)
{
    int value;
    // generate a virtual address for the FPGA lightweight bridge
    LW_virtual = ioremap_nocache(LW_BRIDGE_BASE, LW_BRIDGE_SPAN);

    LEDR_ptr = LW_virtual + LEDR_BASE; // init virtual address for LEDR port

    JP1_ptr = LW_virtual + JP1_BASE; // init virtual address for JP1 port

    KEY_ptr = LW_virtual + KEY_BASE; // init virtual address for KEY port

    *(JP1_ptr + 1) = 0x0000000F; // Set JP1[3:0] to outputs

    // Initialize GPIO data to 0
    *(JP1_ptr + 0) = 0x0;

    // Clear the PIO edgecapture register (clear any pending interrupt)
    *(KEY_ptr + 3) = 0xF;
    // Enable IRQ generation for the 4 buttons
    *(KEY_ptr + 2) = 0xF;

    // Register the interrupt handler.
    value = request_irq(KEYS_IRQ, (irq_handler_t)irq_handler, IRQF_SHARED,
                        "pushbutton_irq_handler", (void *)(irq_handler));
    return value;
}

static void __exit cleanup_pushbutton_handler(void)
{
    *LEDR_ptr = 0;        // Turn off LEDs and de-register irq handler
    *(JP1_ptr + 0) = 0x0; // Clear JP1 outputs
    free_irq(KEYS_IRQ, (void *)irq_handler);
}

void play_sequence()
{
    while (1)
    {
        // Turn on GPIO[0] (tone A)
        *JP1_ptr = 0x1;
        usleep(100000); // 100 ms
        *JP1_ptr = 0x0; // turn off
        usleep(100000); // 100 ms pause
    }
}

module_init(initialize_pushbutton_handler);
module_exit(cleanup_pushbutton_handler);
