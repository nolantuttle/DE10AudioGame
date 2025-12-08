obj-m += button_irq.o
ccflags-y := -Wall -Wextra

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean

install:
	sudo insmod button_irq.ko

.PHONY: all clean	