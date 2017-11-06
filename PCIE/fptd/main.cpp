#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <iostream>
#include <sys/time.h>
#include <ctime>
#include <unistd.h>

#include "asic_data.h"

int main(int argc, char* argv[])
{
	int enable_f=0;
	int sel_f=0;
	int s1=0, s2=0, s3=0;
	uint8_t* data_in;
	uint8_t* tout;
	uint8_t* bit_error;
	uint8_t* dc;
	string mode="0";
	unsigned i, j;
	int result;
	if (argc > 1)
		mode = argv[1];

	if(mode=="1")
		cout<<"Run full decoder!"<<endl<<endl;
	else
		cout<<"Run block test!"<<endl<<endl;

	srand(time(NULL));

	data_in = (uint8_t*)malloc(200*sizeof(uint8_t));
	tout = (uint8_t*)malloc(79*sizeof(uint8_t));
	bit_error = (uint8_t*)malloc(sizeof(uint8_t));
	dc = (uint8_t*)malloc(sizeof(uint8_t));
	for(i=0; i<100; i++){
		for(j=0; j<200; j++){
			data_in[j]=rand()%128;
		}
		result = asic_data(atoi(mode.c_str()), enable_f, sel_f, s1, s2, s3, data_in, tout, bit_error, dc);
		if(!result)
			printf("Test failed\n");
	}
	printf("Test finish\n");
	
	free(data_in);
	free(tout);
	free(bit_error);
	free(dc);
	return 0;
}

