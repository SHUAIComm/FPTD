#include <math.h>
#include <string.h>
#include <stdint.h>
#include "mex.h"
#include "asic_data.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *inMatrix1;
    double *inMatrix2;
    double *inMatrix3;
    double *inMatrix4;
    double *inMatrix5;
    double *inMatrix6;
    double *inMatrix7;             /* 200 input matrix */
    uint8_t mode;
    uint8_t enable_f;
    uint8_t sel_f;
    uint8_t s1;
    uint8_t s2;
    uint8_t s3;
    uint8_t* data_in;
	uint8_t* tout;
	uint8_t* bit_error;
	uint8_t* dc;
    double *outMatrix1;            /* 79 output matrix */    
    double *outMatrix2;            /* 1 output matrix */
    double *outMatrix3;            /* 1 output matrix */
    uint32_t i;
    uint8_t result;
    uint8_t sequence;
    

    /* check for proper number of arguments */
    if((nrhs!=7))
    {
        mexErrMsgIdAndTxt("asic_data_mex:nrhs","Seven inputs required.");
    }
    
    /* create a pointer to the real data in the input matrix  */
    inMatrix1 = mxGetPr(prhs[0]);
    inMatrix2 = mxGetPr(prhs[1]);
    inMatrix3 = mxGetPr(prhs[2]);
    inMatrix4 = mxGetPr(prhs[3]);
    inMatrix5 = mxGetPr(prhs[4]);
    inMatrix6 = mxGetPr(prhs[5]);
    inMatrix7 = mxGetPr(prhs[6]);
    
    mode = inMatrix1[0];
    enable_f = inMatrix2[0];
    sel_f = inMatrix3[0];
    s1 = inMatrix4[0];
    s2 = inMatrix5[0];
    s3 = inMatrix6[0];

    /* allocate memory for the bits */
    data_in = (uint8_t*)malloc(200*sizeof(uint8_t));
    tout = (uint8_t*)malloc(79*sizeof(uint8_t));
	bit_error = (uint8_t*)malloc(sizeof(uint8_t));
	dc = (uint8_t*)malloc(sizeof(uint8_t));

    /* for each bit, copy from the input */
    for(i=0;i<200;i++)
    {
        data_in[i] = inMatrix7[i];
    }
    
    result = asic_data(mode, enable_f, sel_f, s1, s2, s3, data_in, tout, bit_error, dc);
    
    if(!result)
        printf("Error happens in getting data from FPGA");
    
    /* create the output matrix */
    plhs[0] = mxCreateDoubleMatrix(1,(mwSize)79,mxREAL);
    plhs[1] = mxCreateDoubleMatrix(1,(mwSize)1,mxREAL);
    plhs[2] = mxCreateDoubleMatrix(1,(mwSize)1,mxREAL);

    /* get a pointer to the real data in the output matrix */
    outMatrix1 = mxGetPr(plhs[0]);
    outMatrix2 = mxGetPr(plhs[1]);
    outMatrix3 = mxGetPr(plhs[2]);
    
    /* for each bit, copy to the output */
    for(i=0;i<79;i++)
    {
        outMatrix1[i] = tout[i];
    }
    outMatrix2[0] = bit_error[0];
    outMatrix3[0] = dc[0];
    
    /* unallocate the bit memory */
    free(data_in);
	free(tout);
	free(bit_error);
	free(dc);
}

