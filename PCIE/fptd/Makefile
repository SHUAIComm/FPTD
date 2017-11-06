#
TARGET = main

#
CFLAGS = -g -Wall
LDFLAGS = -g -Wall

build: $(TARGET)

main: main.o asic_data.o alt_up_pci_lib.o
	g++ $(LDFLAGS) $^ -o $@

%.o : %.cpp
	g++ $(CFLAGS) -c $< -o $@

.PHONY: clean
clean:
	rm -f $(TARGET) *.a *.o *~
