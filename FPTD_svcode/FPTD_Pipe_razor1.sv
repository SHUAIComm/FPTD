/* FPTD CORE AND CONTROL */
module FPTD_Pipe_razor1 #(parameter FL = 104, parameter DCmax = 256, parameter N = 4, parameter M = 5) 
                             (input logic Clock, 
                              input logic nReset, 
                              input logic Start,
                              input logic [FL-1:0] b1_ideal,
                              input logic signed [2:0][N-1:0] but1, 
                              input logic signed [FL+2:0][N-1:0] bua2, 
                              input logic signed [FL-1:0][N-1:0] bua3, 
                              input logic signed [2:0][N-1:0] blt1, 
                              input logic signed [FL+2:0][N-1:0] bla2,
                              output logic Ready,
                              output logic Valid_Data,
                              output logic unsigned [6:0] Errors,
							  output logic [FL-1:0] b1_error); 

/* Control Unit */
logic Enable_Odd;
logic Enable_Even;
logic Enable_Term;
logic Enable_Error_Counter;
logic nClear;
logic [FL-1:0] b1_error_lower;
logic unsigned [6:0] Error_Count;

Control #(.DCmax(DCmax)) 
Control  (.Clock(Clock),
          .nReset(nReset),
          .Start(Start),
          .Error_Count(Error_Count),
          .nClear(nClear),
          .Enable_Odd(Enable_Odd),
          .Enable_Even(Enable_Even),
          .Enable_Error_Counter(Enable_Error_Counter),
          .Enable_Term(Enable_Term),
          .Valid_Data(Valid_Data),
          .Ready(Ready));
          
// Extrinsic LLRs 
logic signed [FL-1:0][M-1:0] bua1; 
logic signed [FL-1:0][M-1:0] bue1; 
logic signed [FL-1:0][M-1:0] bla1; 
logic signed [FL-1:0][M-1:0] ble1; 
logic signed [FL-1:0][N-1:0] bla3;
logic [FL-1:0] Error_current_bue1;
logic [FL-1:0] Error_current_ble1;
logic [FL-1:0] Error_previous_bue1;
logic [FL-1:0] Error_previous_ble1;

// Instantiate Upper Decoder 
UpperDecoder_Pipe_razor1 #(.FL(FL), .N(N), .M(M)) 
UpperDecoder(.Clock(Clock), 
             .nReset(nReset),
             .nClear(nClear),             
             .Enable_Odd(Enable_Odd),
             .Enable_Even(Enable_Even),
             .Enable_Term(Enable_Term),
             .Enable_Error_Counter(Enable_Error_Counter),
             .b1_ideal(b1_ideal),
             .ba1(bua1), 
             .bt1(but1), 
             .ba2(bua2), 
             .ba3(bua3), 
             .be1(bue1),
             .Error_previous_be1(Error_previous_bue1),
             .Error_current_be1(Error_current_bue1),
             .Error_Count(Error_Count),
             .Error_Count_buff(Errors),
			 .b1_error(b1_error)); 

// Instantiate Lower Decoder 
LowerDecoder_Pipe_razor1 #(.FL(FL), .N(N), .M(M)) 
LowerDecoder(.Clock(Clock), 
             .nReset(nReset),
             .nClear(nClear),
             .Enable_Odd(Enable_Even),
             .Enable_Even(Enable_Odd),
             .Enable_Term(Enable_Term), 
             .Error_previous_be1(Error_previous_ble1),
             .Error_current_be1(Error_current_ble1),            
             .ba1(bla1), 
             .bt1(blt1), 
             .ba2(bla2), 
             .ba3(bla3), 
             .be1(ble1),
			 .b1_error(b1_error_lower)); 

// Interleave systematic bits and provide them to the lower decoder 
assign bla3[0] = bua3[0]; 
assign bla3[1] = bua3[33]; 
assign bla3[2] = bua3[14]; 
assign bla3[3] = bua3[47]; 
assign bla3[4] = bua3[28]; 
assign bla3[5] = bua3[61]; 
assign bla3[6] = bua3[42]; 
assign bla3[7] = bua3[75]; 
assign bla3[8] = bua3[56]; 
assign bla3[9] = bua3[89]; 
assign bla3[10] = bua3[70]; 
assign bla3[11] = bua3[103]; 
assign bla3[12] = bua3[84]; 
assign bla3[13] = bua3[13]; 
assign bla3[14] = bua3[98]; 
assign bla3[15] = bua3[27]; 
assign bla3[16] = bua3[8]; 
assign bla3[17] = bua3[41]; 
assign bla3[18] = bua3[22]; 
assign bla3[19] = bua3[55]; 
assign bla3[20] = bua3[36]; 
assign bla3[21] = bua3[69]; 
assign bla3[22] = bua3[50]; 
assign bla3[23] = bua3[83]; 
assign bla3[24] = bua3[64]; 
assign bla3[25] = bua3[97]; 
assign bla3[26] = bua3[78]; 
assign bla3[27] = bua3[7]; 
assign bla3[28] = bua3[92]; 
assign bla3[29] = bua3[21]; 
assign bla3[30] = bua3[2]; 
assign bla3[31] = bua3[35]; 
assign bla3[32] = bua3[16]; 
assign bla3[33] = bua3[49]; 
assign bla3[34] = bua3[30]; 
assign bla3[35] = bua3[63]; 
assign bla3[36] = bua3[44]; 
assign bla3[37] = bua3[77]; 
assign bla3[38] = bua3[58]; 
assign bla3[39] = bua3[91]; 
assign bla3[40] = bua3[72]; 
assign bla3[41] = bua3[1]; 
assign bla3[42] = bua3[86]; 
assign bla3[43] = bua3[15]; 
assign bla3[44] = bua3[100]; 
assign bla3[45] = bua3[29]; 
assign bla3[46] = bua3[10]; 
assign bla3[47] = bua3[43]; 
assign bla3[48] = bua3[24]; 
assign bla3[49] = bua3[57]; 
assign bla3[50] = bua3[38]; 
assign bla3[51] = bua3[71]; 
assign bla3[52] = bua3[52]; 
assign bla3[53] = bua3[85]; 
assign bla3[54] = bua3[66]; 
assign bla3[55] = bua3[99]; 
assign bla3[56] = bua3[80]; 
assign bla3[57] = bua3[9]; 
assign bla3[58] = bua3[94]; 
assign bla3[59] = bua3[23]; 
assign bla3[60] = bua3[4]; 
assign bla3[61] = bua3[37]; 
assign bla3[62] = bua3[18]; 
assign bla3[63] = bua3[51]; 
assign bla3[64] = bua3[32]; 
assign bla3[65] = bua3[65]; 
assign bla3[66] = bua3[46]; 
assign bla3[67] = bua3[79]; 
assign bla3[68] = bua3[60]; 
assign bla3[69] = bua3[93]; 
assign bla3[70] = bua3[74]; 
assign bla3[71] = bua3[3]; 
assign bla3[72] = bua3[88]; 
assign bla3[73] = bua3[17]; 
assign bla3[74] = bua3[102]; 
assign bla3[75] = bua3[31]; 
assign bla3[76] = bua3[12]; 
assign bla3[77] = bua3[45]; 
assign bla3[78] = bua3[26]; 
assign bla3[79] = bua3[59]; 
assign bla3[80] = bua3[40]; 
assign bla3[81] = bua3[73]; 
assign bla3[82] = bua3[54]; 
assign bla3[83] = bua3[87]; 
assign bla3[84] = bua3[68]; 
assign bla3[85] = bua3[101]; 
assign bla3[86] = bua3[82]; 
assign bla3[87] = bua3[11]; 
assign bla3[88] = bua3[96]; 
assign bla3[89] = bua3[25]; 
assign bla3[90] = bua3[6]; 
assign bla3[91] = bua3[39]; 
assign bla3[92] = bua3[20]; 
assign bla3[93] = bua3[53]; 
assign bla3[94] = bua3[34]; 
assign bla3[95] = bua3[67]; 
assign bla3[96] = bua3[48]; 
assign bla3[97] = bua3[81]; 
assign bla3[98] = bua3[62]; 
assign bla3[99] = bua3[95]; 
assign bla3[100] = bua3[76]; 
assign bla3[101] = bua3[5]; 
assign bla3[102] = bua3[90]; 
assign bla3[103] = bua3[19]; 
// Interleave upper extrinsic into lower apriori 
assign bla1[0] = bue1[0]; 
assign bla1[1] = bue1[33]; 
assign bla1[2] = bue1[14]; 
assign bla1[3] = bue1[47]; 
assign bla1[4] = bue1[28]; 
assign bla1[5] = bue1[61]; 
assign bla1[6] = bue1[42]; 
assign bla1[7] = bue1[75]; 
assign bla1[8] = bue1[56]; 
assign bla1[9] = bue1[89]; 
assign bla1[10] = bue1[70]; 
assign bla1[11] = bue1[103]; 
assign bla1[12] = bue1[84]; 
assign bla1[13] = bue1[13]; 
assign bla1[14] = bue1[98]; 
assign bla1[15] = bue1[27]; 
assign bla1[16] = bue1[8]; 
assign bla1[17] = bue1[41]; 
assign bla1[18] = bue1[22]; 
assign bla1[19] = bue1[55]; 
assign bla1[20] = bue1[36]; 
assign bla1[21] = bue1[69]; 
assign bla1[22] = bue1[50]; 
assign bla1[23] = bue1[83]; 
assign bla1[24] = bue1[64]; 
assign bla1[25] = bue1[97]; 
assign bla1[26] = bue1[78]; 
assign bla1[27] = bue1[7]; 
assign bla1[28] = bue1[92]; 
assign bla1[29] = bue1[21]; 
assign bla1[30] = bue1[2]; 
assign bla1[31] = bue1[35]; 
assign bla1[32] = bue1[16]; 
assign bla1[33] = bue1[49]; 
assign bla1[34] = bue1[30]; 
assign bla1[35] = bue1[63]; 
assign bla1[36] = bue1[44]; 
assign bla1[37] = bue1[77]; 
assign bla1[38] = bue1[58]; 
assign bla1[39] = bue1[91]; 
assign bla1[40] = bue1[72]; 
assign bla1[41] = bue1[1]; 
assign bla1[42] = bue1[86]; 
assign bla1[43] = bue1[15]; 
assign bla1[44] = bue1[100]; 
assign bla1[45] = bue1[29]; 
assign bla1[46] = bue1[10]; 
assign bla1[47] = bue1[43]; 
assign bla1[48] = bue1[24]; 
assign bla1[49] = bue1[57]; 
assign bla1[50] = bue1[38]; 
assign bla1[51] = bue1[71]; 
assign bla1[52] = bue1[52]; 
assign bla1[53] = bue1[85]; 
assign bla1[54] = bue1[66]; 
assign bla1[55] = bue1[99]; 
assign bla1[56] = bue1[80]; 
assign bla1[57] = bue1[9]; 
assign bla1[58] = bue1[94]; 
assign bla1[59] = bue1[23]; 
assign bla1[60] = bue1[4]; 
assign bla1[61] = bue1[37]; 
assign bla1[62] = bue1[18]; 
assign bla1[63] = bue1[51]; 
assign bla1[64] = bue1[32]; 
assign bla1[65] = bue1[65]; 
assign bla1[66] = bue1[46]; 
assign bla1[67] = bue1[79]; 
assign bla1[68] = bue1[60]; 
assign bla1[69] = bue1[93]; 
assign bla1[70] = bue1[74]; 
assign bla1[71] = bue1[3]; 
assign bla1[72] = bue1[88]; 
assign bla1[73] = bue1[17]; 
assign bla1[74] = bue1[102]; 
assign bla1[75] = bue1[31]; 
assign bla1[76] = bue1[12]; 
assign bla1[77] = bue1[45]; 
assign bla1[78] = bue1[26]; 
assign bla1[79] = bue1[59]; 
assign bla1[80] = bue1[40]; 
assign bla1[81] = bue1[73]; 
assign bla1[82] = bue1[54]; 
assign bla1[83] = bue1[87]; 
assign bla1[84] = bue1[68]; 
assign bla1[85] = bue1[101]; 
assign bla1[86] = bue1[82]; 
assign bla1[87] = bue1[11]; 
assign bla1[88] = bue1[96]; 
assign bla1[89] = bue1[25]; 
assign bla1[90] = bue1[6]; 
assign bla1[91] = bue1[39]; 
assign bla1[92] = bue1[20]; 
assign bla1[93] = bue1[53]; 
assign bla1[94] = bue1[34]; 
assign bla1[95] = bue1[67]; 
assign bla1[96] = bue1[48]; 
assign bla1[97] = bue1[81]; 
assign bla1[98] = bue1[62]; 
assign bla1[99] = bue1[95]; 
assign bla1[100] = bue1[76]; 
assign bla1[101] = bue1[5]; 
assign bla1[102] = bue1[90]; 
assign bla1[103] = bue1[19]; 
// Interleave lower extrinsic into upper apriori 
assign bua1[0] = ble1[0]; 
assign bua1[33] = ble1[1]; 
assign bua1[14] = ble1[2]; 
assign bua1[47] = ble1[3]; 
assign bua1[28] = ble1[4]; 
assign bua1[61] = ble1[5]; 
assign bua1[42] = ble1[6]; 
assign bua1[75] = ble1[7]; 
assign bua1[56] = ble1[8]; 
assign bua1[89] = ble1[9]; 
assign bua1[70] = ble1[10]; 
assign bua1[103] = ble1[11]; 
assign bua1[84] = ble1[12]; 
assign bua1[13] = ble1[13]; 
assign bua1[98] = ble1[14]; 
assign bua1[27] = ble1[15]; 
assign bua1[8] = ble1[16]; 
assign bua1[41] = ble1[17]; 
assign bua1[22] = ble1[18]; 
assign bua1[55] = ble1[19]; 
assign bua1[36] = ble1[20]; 
assign bua1[69] = ble1[21]; 
assign bua1[50] = ble1[22]; 
assign bua1[83] = ble1[23]; 
assign bua1[64] = ble1[24]; 
assign bua1[97] = ble1[25]; 
assign bua1[78] = ble1[26]; 
assign bua1[7] = ble1[27]; 
assign bua1[92] = ble1[28]; 
assign bua1[21] = ble1[29]; 
assign bua1[2] = ble1[30]; 
assign bua1[35] = ble1[31]; 
assign bua1[16] = ble1[32]; 
assign bua1[49] = ble1[33]; 
assign bua1[30] = ble1[34]; 
assign bua1[63] = ble1[35]; 
assign bua1[44] = ble1[36]; 
assign bua1[77] = ble1[37]; 
assign bua1[58] = ble1[38]; 
assign bua1[91] = ble1[39]; 
assign bua1[72] = ble1[40]; 
assign bua1[1] = ble1[41]; 
assign bua1[86] = ble1[42]; 
assign bua1[15] = ble1[43]; 
assign bua1[100] = ble1[44]; 
assign bua1[29] = ble1[45]; 
assign bua1[10] = ble1[46]; 
assign bua1[43] = ble1[47]; 
assign bua1[24] = ble1[48]; 
assign bua1[57] = ble1[49]; 
assign bua1[38] = ble1[50]; 
assign bua1[71] = ble1[51]; 
assign bua1[52] = ble1[52]; 
assign bua1[85] = ble1[53]; 
assign bua1[66] = ble1[54]; 
assign bua1[99] = ble1[55]; 
assign bua1[80] = ble1[56]; 
assign bua1[9] = ble1[57]; 
assign bua1[94] = ble1[58]; 
assign bua1[23] = ble1[59]; 
assign bua1[4] = ble1[60]; 
assign bua1[37] = ble1[61]; 
assign bua1[18] = ble1[62]; 
assign bua1[51] = ble1[63]; 
assign bua1[32] = ble1[64]; 
assign bua1[65] = ble1[65]; 
assign bua1[46] = ble1[66]; 
assign bua1[79] = ble1[67]; 
assign bua1[60] = ble1[68]; 
assign bua1[93] = ble1[69]; 
assign bua1[74] = ble1[70]; 
assign bua1[3] = ble1[71]; 
assign bua1[88] = ble1[72]; 
assign bua1[17] = ble1[73]; 
assign bua1[102] = ble1[74]; 
assign bua1[31] = ble1[75]; 
assign bua1[12] = ble1[76]; 
assign bua1[45] = ble1[77]; 
assign bua1[26] = ble1[78]; 
assign bua1[59] = ble1[79]; 
assign bua1[40] = ble1[80]; 
assign bua1[73] = ble1[81]; 
assign bua1[54] = ble1[82]; 
assign bua1[87] = ble1[83]; 
assign bua1[68] = ble1[84]; 
assign bua1[101] = ble1[85]; 
assign bua1[82] = ble1[86]; 
assign bua1[11] = ble1[87]; 
assign bua1[96] = ble1[88]; 
assign bua1[25] = ble1[89]; 
assign bua1[6] = ble1[90]; 
assign bua1[39] = ble1[91]; 
assign bua1[20] = ble1[92]; 
assign bua1[53] = ble1[93]; 
assign bua1[34] = ble1[94]; 
assign bua1[67] = ble1[95]; 
assign bua1[48] = ble1[96]; 
assign bua1[81] = ble1[97]; 
assign bua1[62] = ble1[98]; 
assign bua1[95] = ble1[99]; 
assign bua1[76] = ble1[100]; 
assign bua1[5] = ble1[101]; 
assign bua1[90] = ble1[102]; 
assign bua1[19] = ble1[103]; 

// Interleave upper extrinsic into lower apriori 
assign Error_previous_ble1[0] = Error_current_bue1[0]; 
assign Error_previous_ble1[1] = Error_current_bue1[33]; 
assign Error_previous_ble1[2] = Error_current_bue1[14]; 
assign Error_previous_ble1[3] = Error_current_bue1[47]; 
assign Error_previous_ble1[4] = Error_current_bue1[28]; 
assign Error_previous_ble1[5] = Error_current_bue1[61]; 
assign Error_previous_ble1[6] = Error_current_bue1[42]; 
assign Error_previous_ble1[7] = Error_current_bue1[75]; 
assign Error_previous_ble1[8] = Error_current_bue1[56]; 
assign Error_previous_ble1[9] = Error_current_bue1[89]; 
assign Error_previous_ble1[10] = Error_current_bue1[70]; 
assign Error_previous_ble1[11] = Error_current_bue1[103]; 
assign Error_previous_ble1[12] = Error_current_bue1[84]; 
assign Error_previous_ble1[13] = Error_current_bue1[13]; 
assign Error_previous_ble1[14] = Error_current_bue1[98]; 
assign Error_previous_ble1[15] = Error_current_bue1[27]; 
assign Error_previous_ble1[16] = Error_current_bue1[8]; 
assign Error_previous_ble1[17] = Error_current_bue1[41]; 
assign Error_previous_ble1[18] = Error_current_bue1[22]; 
assign Error_previous_ble1[19] = Error_current_bue1[55]; 
assign Error_previous_ble1[20] = Error_current_bue1[36]; 
assign Error_previous_ble1[21] = Error_current_bue1[69]; 
assign Error_previous_ble1[22] = Error_current_bue1[50]; 
assign Error_previous_ble1[23] = Error_current_bue1[83]; 
assign Error_previous_ble1[24] = Error_current_bue1[64]; 
assign Error_previous_ble1[25] = Error_current_bue1[97]; 
assign Error_previous_ble1[26] = Error_current_bue1[78]; 
assign Error_previous_ble1[27] = Error_current_bue1[7]; 
assign Error_previous_ble1[28] = Error_current_bue1[92]; 
assign Error_previous_ble1[29] = Error_current_bue1[21]; 
assign Error_previous_ble1[30] = Error_current_bue1[2]; 
assign Error_previous_ble1[31] = Error_current_bue1[35]; 
assign Error_previous_ble1[32] = Error_current_bue1[16]; 
assign Error_previous_ble1[33] = Error_current_bue1[49]; 
assign Error_previous_ble1[34] = Error_current_bue1[30]; 
assign Error_previous_ble1[35] = Error_current_bue1[63]; 
assign Error_previous_ble1[36] = Error_current_bue1[44]; 
assign Error_previous_ble1[37] = Error_current_bue1[77]; 
assign Error_previous_ble1[38] = Error_current_bue1[58]; 
assign Error_previous_ble1[39] = Error_current_bue1[91]; 
assign Error_previous_ble1[40] = Error_current_bue1[72]; 
assign Error_previous_ble1[41] = Error_current_bue1[1]; 
assign Error_previous_ble1[42] = Error_current_bue1[86]; 
assign Error_previous_ble1[43] = Error_current_bue1[15]; 
assign Error_previous_ble1[44] = Error_current_bue1[100]; 
assign Error_previous_ble1[45] = Error_current_bue1[29]; 
assign Error_previous_ble1[46] = Error_current_bue1[10]; 
assign Error_previous_ble1[47] = Error_current_bue1[43]; 
assign Error_previous_ble1[48] = Error_current_bue1[24]; 
assign Error_previous_ble1[49] = Error_current_bue1[57]; 
assign Error_previous_ble1[50] = Error_current_bue1[38]; 
assign Error_previous_ble1[51] = Error_current_bue1[71]; 
assign Error_previous_ble1[52] = Error_current_bue1[52]; 
assign Error_previous_ble1[53] = Error_current_bue1[85]; 
assign Error_previous_ble1[54] = Error_current_bue1[66]; 
assign Error_previous_ble1[55] = Error_current_bue1[99]; 
assign Error_previous_ble1[56] = Error_current_bue1[80]; 
assign Error_previous_ble1[57] = Error_current_bue1[9]; 
assign Error_previous_ble1[58] = Error_current_bue1[94]; 
assign Error_previous_ble1[59] = Error_current_bue1[23]; 
assign Error_previous_ble1[60] = Error_current_bue1[4]; 
assign Error_previous_ble1[61] = Error_current_bue1[37]; 
assign Error_previous_ble1[62] = Error_current_bue1[18]; 
assign Error_previous_ble1[63] = Error_current_bue1[51]; 
assign Error_previous_ble1[64] = Error_current_bue1[32]; 
assign Error_previous_ble1[65] = Error_current_bue1[65]; 
assign Error_previous_ble1[66] = Error_current_bue1[46]; 
assign Error_previous_ble1[67] = Error_current_bue1[79]; 
assign Error_previous_ble1[68] = Error_current_bue1[60]; 
assign Error_previous_ble1[69] = Error_current_bue1[93]; 
assign Error_previous_ble1[70] = Error_current_bue1[74]; 
assign Error_previous_ble1[71] = Error_current_bue1[3]; 
assign Error_previous_ble1[72] = Error_current_bue1[88]; 
assign Error_previous_ble1[73] = Error_current_bue1[17]; 
assign Error_previous_ble1[74] = Error_current_bue1[102]; 
assign Error_previous_ble1[75] = Error_current_bue1[31]; 
assign Error_previous_ble1[76] = Error_current_bue1[12]; 
assign Error_previous_ble1[77] = Error_current_bue1[45]; 
assign Error_previous_ble1[78] = Error_current_bue1[26]; 
assign Error_previous_ble1[79] = Error_current_bue1[59]; 
assign Error_previous_ble1[80] = Error_current_bue1[40]; 
assign Error_previous_ble1[81] = Error_current_bue1[73]; 
assign Error_previous_ble1[82] = Error_current_bue1[54]; 
assign Error_previous_ble1[83] = Error_current_bue1[87]; 
assign Error_previous_ble1[84] = Error_current_bue1[68]; 
assign Error_previous_ble1[85] = Error_current_bue1[101]; 
assign Error_previous_ble1[86] = Error_current_bue1[82]; 
assign Error_previous_ble1[87] = Error_current_bue1[11]; 
assign Error_previous_ble1[88] = Error_current_bue1[96]; 
assign Error_previous_ble1[89] = Error_current_bue1[25]; 
assign Error_previous_ble1[90] = Error_current_bue1[6]; 
assign Error_previous_ble1[91] = Error_current_bue1[39]; 
assign Error_previous_ble1[92] = Error_current_bue1[20]; 
assign Error_previous_ble1[93] = Error_current_bue1[53]; 
assign Error_previous_ble1[94] = Error_current_bue1[34]; 
assign Error_previous_ble1[95] = Error_current_bue1[67]; 
assign Error_previous_ble1[96] = Error_current_bue1[48]; 
assign Error_previous_ble1[97] = Error_current_bue1[81]; 
assign Error_previous_ble1[98] = Error_current_bue1[62]; 
assign Error_previous_ble1[99] = Error_current_bue1[95]; 
assign Error_previous_ble1[100] = Error_current_bue1[76]; 
assign Error_previous_ble1[101] = Error_current_bue1[5]; 
assign Error_previous_ble1[102] = Error_current_bue1[90]; 
assign Error_previous_ble1[103] = Error_current_bue1[19]; 
// Interleave lower extrinsic into upper apriori 
assign Error_previous_bue1[0] = Error_current_ble1[0]; 
assign Error_previous_bue1[33] = Error_current_ble1[1]; 
assign Error_previous_bue1[14] = Error_current_ble1[2]; 
assign Error_previous_bue1[47] = Error_current_ble1[3]; 
assign Error_previous_bue1[28] = Error_current_ble1[4]; 
assign Error_previous_bue1[61] = Error_current_ble1[5]; 
assign Error_previous_bue1[42] = Error_current_ble1[6]; 
assign Error_previous_bue1[75] = Error_current_ble1[7]; 
assign Error_previous_bue1[56] = Error_current_ble1[8]; 
assign Error_previous_bue1[89] = Error_current_ble1[9]; 
assign Error_previous_bue1[70] = Error_current_ble1[10]; 
assign Error_previous_bue1[103] = Error_current_ble1[11]; 
assign Error_previous_bue1[84] = Error_current_ble1[12]; 
assign Error_previous_bue1[13] = Error_current_ble1[13]; 
assign Error_previous_bue1[98] = Error_current_ble1[14]; 
assign Error_previous_bue1[27] = Error_current_ble1[15]; 
assign Error_previous_bue1[8] = Error_current_ble1[16]; 
assign Error_previous_bue1[41] = Error_current_ble1[17]; 
assign Error_previous_bue1[22] = Error_current_ble1[18]; 
assign Error_previous_bue1[55] = Error_current_ble1[19]; 
assign Error_previous_bue1[36] = Error_current_ble1[20]; 
assign Error_previous_bue1[69] = Error_current_ble1[21]; 
assign Error_previous_bue1[50] = Error_current_ble1[22]; 
assign Error_previous_bue1[83] = Error_current_ble1[23]; 
assign Error_previous_bue1[64] = Error_current_ble1[24]; 
assign Error_previous_bue1[97] = Error_current_ble1[25]; 
assign Error_previous_bue1[78] = Error_current_ble1[26]; 
assign Error_previous_bue1[7] = Error_current_ble1[27]; 
assign Error_previous_bue1[92] = Error_current_ble1[28]; 
assign Error_previous_bue1[21] = Error_current_ble1[29]; 
assign Error_previous_bue1[2] = Error_current_ble1[30]; 
assign Error_previous_bue1[35] = Error_current_ble1[31]; 
assign Error_previous_bue1[16] = Error_current_ble1[32]; 
assign Error_previous_bue1[49] = Error_current_ble1[33]; 
assign Error_previous_bue1[30] = Error_current_ble1[34]; 
assign Error_previous_bue1[63] = Error_current_ble1[35]; 
assign Error_previous_bue1[44] = Error_current_ble1[36]; 
assign Error_previous_bue1[77] = Error_current_ble1[37]; 
assign Error_previous_bue1[58] = Error_current_ble1[38]; 
assign Error_previous_bue1[91] = Error_current_ble1[39]; 
assign Error_previous_bue1[72] = Error_current_ble1[40]; 
assign Error_previous_bue1[1] = Error_current_ble1[41]; 
assign Error_previous_bue1[86] = Error_current_ble1[42]; 
assign Error_previous_bue1[15] = Error_current_ble1[43]; 
assign Error_previous_bue1[100] = Error_current_ble1[44]; 
assign Error_previous_bue1[29] = Error_current_ble1[45]; 
assign Error_previous_bue1[10] = Error_current_ble1[46]; 
assign Error_previous_bue1[43] = Error_current_ble1[47]; 
assign Error_previous_bue1[24] = Error_current_ble1[48]; 
assign Error_previous_bue1[57] = Error_current_ble1[49]; 
assign Error_previous_bue1[38] = Error_current_ble1[50]; 
assign Error_previous_bue1[71] = Error_current_ble1[51]; 
assign Error_previous_bue1[52] = Error_current_ble1[52]; 
assign Error_previous_bue1[85] = Error_current_ble1[53]; 
assign Error_previous_bue1[66] = Error_current_ble1[54]; 
assign Error_previous_bue1[99] = Error_current_ble1[55]; 
assign Error_previous_bue1[80] = Error_current_ble1[56]; 
assign Error_previous_bue1[9] = Error_current_ble1[57]; 
assign Error_previous_bue1[94] = Error_current_ble1[58]; 
assign Error_previous_bue1[23] = Error_current_ble1[59]; 
assign Error_previous_bue1[4] = Error_current_ble1[60]; 
assign Error_previous_bue1[37] = Error_current_ble1[61]; 
assign Error_previous_bue1[18] = Error_current_ble1[62]; 
assign Error_previous_bue1[51] = Error_current_ble1[63]; 
assign Error_previous_bue1[32] = Error_current_ble1[64]; 
assign Error_previous_bue1[65] = Error_current_ble1[65]; 
assign Error_previous_bue1[46] = Error_current_ble1[66]; 
assign Error_previous_bue1[79] = Error_current_ble1[67]; 
assign Error_previous_bue1[60] = Error_current_ble1[68]; 
assign Error_previous_bue1[93] = Error_current_ble1[69]; 
assign Error_previous_bue1[74] = Error_current_ble1[70]; 
assign Error_previous_bue1[3] = Error_current_ble1[71]; 
assign Error_previous_bue1[88] = Error_current_ble1[72]; 
assign Error_previous_bue1[17] = Error_current_ble1[73]; 
assign Error_previous_bue1[102] = Error_current_ble1[74]; 
assign Error_previous_bue1[31] = Error_current_ble1[75]; 
assign Error_previous_bue1[12] = Error_current_ble1[76]; 
assign Error_previous_bue1[45] = Error_current_ble1[77]; 
assign Error_previous_bue1[26] = Error_current_ble1[78]; 
assign Error_previous_bue1[59] = Error_current_ble1[79]; 
assign Error_previous_bue1[40] = Error_current_ble1[80]; 
assign Error_previous_bue1[73] = Error_current_ble1[81]; 
assign Error_previous_bue1[54] = Error_current_ble1[82]; 
assign Error_previous_bue1[87] = Error_current_ble1[83]; 
assign Error_previous_bue1[68] = Error_current_ble1[84]; 
assign Error_previous_bue1[101] = Error_current_ble1[85]; 
assign Error_previous_bue1[82] = Error_current_ble1[86]; 
assign Error_previous_bue1[11] = Error_current_ble1[87]; 
assign Error_previous_bue1[96] = Error_current_ble1[88]; 
assign Error_previous_bue1[25] = Error_current_ble1[89]; 
assign Error_previous_bue1[6] = Error_current_ble1[90]; 
assign Error_previous_bue1[39] = Error_current_ble1[91]; 
assign Error_previous_bue1[20] = Error_current_ble1[92]; 
assign Error_previous_bue1[53] = Error_current_ble1[93]; 
assign Error_previous_bue1[34] = Error_current_ble1[94]; 
assign Error_previous_bue1[67] = Error_current_ble1[95]; 
assign Error_previous_bue1[48] = Error_current_ble1[96]; 
assign Error_previous_bue1[81] = Error_current_ble1[97]; 
assign Error_previous_bue1[62] = Error_current_ble1[98]; 
assign Error_previous_bue1[95] = Error_current_ble1[99]; 
assign Error_previous_bue1[76] = Error_current_ble1[100]; 
assign Error_previous_bue1[5] = Error_current_ble1[101]; 
assign Error_previous_bue1[90] = Error_current_ble1[102]; 
assign Error_previous_bue1[19] = Error_current_ble1[103]; 
endmodule
