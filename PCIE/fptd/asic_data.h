#include <stdio.h>
#include <stdint.h>
#include <iostream>
#include <sys/time.h>
#include <ctime>
#include <unistd.h>
#include <vector>
#include <cmath>
#include <string>
#include <algorithm>
using namespace std;

#include "alt_up_pci_lib.h"

#define ONCHIP_CONTROL  0x00000FFF
#define ONCHIP_DATA     0x00001000

#define DATA_SIZE 		4096
#define CTRLLER_ID 		0

int asic_data(int mode, int enable_f, int sel_f, int s1, int s2, int s3, uint8_t* data_in, uint8_t* test_out, uint8_t* bit_error, uint8_t* dc);

