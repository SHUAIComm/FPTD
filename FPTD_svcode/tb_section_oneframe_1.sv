`timescale 1ns/1ps
module tb_section_oneframe_1;
parameter N1 = 200;
parameter N2 = 7;
parameter N3 = 89; //used to be 84
parameter N4 = 76;
parameter FL = 104;
parameter N = 4; 
parameter M = 5;
parameter Eb_N0 = 0.0;
parameter FrameLength = 104;
parameter TCLK = 100;
parameter num_TCLK = 100; 
//parameter num_frames = 10000;
parameter num_iteration = 100;
parameter DCmax=200;
parameter State = 7*M;
logic Clock;
logic nReset;
logic Enable_Odd;
logic Enable_Even;
logic Enable_Term;
logic Enable_Error_Counter;


// Input LLRs
// Upper decoder
logic signed [FrameLength+2:0][M-1:0] bua1; 
logic signed [num_iteration:1][FrameLength+2:0][M-1:0] bua1_mem; 
logic signed [FrameLength+2:0][N-1:0] bua2; 
logic signed [FrameLength+2:0][N-1:0] bua3;
logic signed [FrameLength+2:0][State-1:0] upper_alpha_in;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_alpha_in_mem;
logic signed [FrameLength+2:0][State-1:0]upper_alpha_out;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_alpha_out_mem;
logic signed [FrameLength+2:0][State-1:0] upper_beta_in;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_beta_in_mem;
logic signed [FrameLength+2:0][State-1:0] upper_beta_out;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_beta_out_mem;
logic signed [FrameLength+2:0][M-1:0] upper_be1;
logic signed [num_iteration:1][FrameLength+2:0][M-1:0] upper_be1_mem;
logic signed [FrameLength+2:0][M-1:0] upper_result;
logic signed [num_iteration:1][FrameLength+2:0][M-1:0] upper_result_mem;
logic signed [FrameLength+2:0] b1_ideal;

logic signed [num_iteration:1][FrameLength+2:0][N3:1] upper_output;
logic signed [num_iteration:1][FrameLength+2:0][N3:1] lower_output;



logic signed [FrameLength+2:0][State-1:0]upper_alpha_out_matlab;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_alpha_out_mem_matlab;
logic signed [FrameLength+2:0][State-1:0] upper_beta_out_matlab;
logic signed [num_iteration:1][FrameLength+2:0][State-1:0] upper_beta_out_mem_matlab;
// Lower decoder
//logic signed [FrameLength+2:0][M-1:0] bla1; 
//logic signed  [num_iteration:1][FrameLength+2:0][M-1:0] bla1_mem; 
//logic signed [FrameLength+2:0][N-1:0] bla2;
//logic signed [FrameLength+2:0][N-1:0] bla3; 
//logic signed [FrameLength+2:0][State-1:0] lower_alpha_in;
//logic signed  [num_iteration:1][FrameLength+2:0][State-1:0] lower_alpha_in_mem;
//logic signed [FrameLength+2:0][State-1:0] lower_alpha_out;
//logic signed  [num_iteration:1][FrameLength+2:0][State-1:0] lower_alpha_out_mem;
//logic signed [FrameLength+2:0][State-1:0] lower_beta_in;
//logic signed  [num_iteration:1][FrameLength+2:0][State-1:0] lower_beta_in_mem;
//logic signed [FrameLength+2:0][State-1:0] lower_beta_out;
//logic signed  [num_iteration:1][FrameLength+2:0][State-1:0] lower_beta_out_mem;
//logic signed [FrameLength+2:0][M-1:0] lower_be1;
//logic signed  [num_iteration:1][FrameLength+2:0][M-1:0] lower_be1_mem;
logic signed [num_iteration:1][FrameLength+2:0] upper_error;
logic signed [N2-1:0][N1-1:0] BusData;
logic signed [N2-1:0] In;
logic signed [N2-1:0] DOut1;
logic signed [N2-1:0] DOut2;
logic signed [6:0] TOut;
logic signed [N2-1:0][N4-1:0] TOutData;
logic Mode;
logic Enable_f;
logic Sel_f;
logic S1;
logic S2;
logic S3;
logic Dclk;
logic TestReady;
logic Go;
logic bitout1;
logic bitout2;
logic KeepShift;
logic Start;
logic Outshift;
logic Outkeep;
// Output bits
logic [FrameLength+2:0] b1_MATLAB_mem;
logic [FrameLength+2:0] b1_MATLAB ;
logic unsigned [6:0] Errors ;
logic enable_reg;


ASIC ASIC1 (
 .nReset(nReset),
 .Clock(Clock),
 .Mode(Mode),
 .Go(Go),
 .Enable_f(Enable_f),
 .Sel_f(Sel_f),
 .S1(S1),
 .S2(S2),
 .S3(S3),
 .In(In),
 .DOut1(DOut1),
 .DOut2(DOut2),
 .TOut(TOut),
 .bitout1(bitout1),
 .bitout2(bitout2),
 .KeepShift(KeepShift),
 .Start(Start),
 .Start2(Start2),
 .TestReady(TestReady),
 .Dclk(Dclk)
);


/* FPTD #(.FrameLength(40), .DCmax(DCmax), .N(4), .M(5)) 
FPTD             (.Clock(Clock), 
                  .nReset(nReset), 
                  .Start(Start), 
                  .b1_ideal(b1_MATLAB),
                  .but1(but1), 
                  .bua2(bua2), 
                  .bua3(bua3), 
                  .blt1(blt1), 
                  .bla2(bla2), 
//                  .bla3(bla3), 
                  .Ready(Ready),
                  .Errors(Errors)); */
				  
int x;                              
// Clock process
always
begin
    Clock = 1'b0;
    #(0.5*TCLK);
    Clock = 1'b1;
    #(0.5*TCLK);
end

always
begin
#(0.4*TCLK*(1+(2*(2-Sel_f)-1)*Enable_f));
if (!Start2)
begin
for (x=N1-1;x>0;x=x-1)
begin
    BusData[0][x]=BusData[0][x-1];
    BusData[1][x]=BusData[1][x-1];
    BusData[2][x]=BusData[2][x-1];
    BusData[3][x]=BusData[3][x-1];
    BusData[4][x]=BusData[4][x-1];
    BusData[5][x]=BusData[5][x-1];
    BusData[6][x]=BusData[6][x-1];
end
end
#(0.6*TCLK*(1+(2*(2-Sel_f)-1)*Enable_f));
end

// nReset process
initial 
begin
    //nReset = 1'b1;
    //#(0.25*TCLK);
    nReset = 1'b0;
    #(0.25*TCLK);
    nReset = 1'b1;
end

// always@(posedge Clock)
// begin
 // In[0] <= BusData[0][N1-1];
 // In[1] <= BusData[1][N1-1];
 // In[2] <= BusData[2][N1-1];
 // In[3] <= BusData[3][N1-1];
 // In[4] <= BusData[4][N1-1];
 // In[5] <= BusData[5][N1-1];
// end

assign In[0] = BusData[0][N1-1];
assign In[1] = BusData[1][N1-1];
assign In[2] = BusData[2][N1-1];
assign In[3] = BusData[3][N1-1];
assign In[4] = BusData[4][N1-1];
assign In[5] = BusData[5][N1-1];
assign In[6] = BusData[6][N1-1];

initial
begin
    bua1 = 0;
    bua2 = 0;
    bua3 = 0;
    upper_alpha_in = 0;
    upper_beta_in = 0;
    b1_MATLAB = 0;
    BusData = 0;
    upper_alpha_out = 0;
    upper_beta_out = 0;
    upper_result = 0;
    enable_reg = 0;
//    bla1 = 0;
//    bla2 = 0;
//    bla3 = 0; 
//    lower_alpha_in = 0;
//    lower_beta_in = 0;
// Mode = 1 for decoder test, Mode = 0 for section test
    Mode = 0;
    Enable_f = 0;
    Sel_f = 0;
//S1,S2,S3 combinations for different blocks to test.
//001 benchmark; 101 proposed; 011 RCP; 111 BTWC.
    S1 = 0;
    S2 = 0;
    S3 = 1;
    Go = 0;
    wait(nReset);
    $display("nReset");
    //forever
    //begin
        #(3.2*TCLK);
        Go = 1;
        //wait(ASIC1.FPTD1.Ready);
        //wait(!ASIC1.FPTD1.Ready);
		//$stop;
    //end
    #3000us
    $finish;
end

always
begin	#2000us
	$stop;
end

// Format strings
string Eb_N0_str;
string N_str;
string M_str;
string FrameLength_str;
initial 
begin 
    $sformat(Eb_N0_str,"%1.2f",Eb_N0);
    N_str.itoa(N);
    M_str.itoa(M);
    FrameLength_str.itoa(FrameLength);
end

// Function to read data from files
// File names 
string f_bua1;
string f_bua2;
string f_bua3;
//string f_bla1;
//string f_bla2;
//string f_bla3;
string f_upper_alpha_in;
string f_upper_beta_in;
string f_upper_alpha_out;
string f_upper_beta_out;
string f_b1_ideal;
string f_upper_output;
string f_lower_output;
//string f_lower_alpha_in;
//string f_lower_beta_in;

//string f_upper_alpha_out;
//string f_upper_beta_out;
//string f_lower_alpha_out;
//string f_lower_beta_out;

string f_b1_MATLAB;
// File handlers
integer f_hndl_bua1;
integer f_hndl_bua2 ;
integer f_hndl_bua3 ; 
//integer f_hndl_bla1;
//integer f_hndl_bla2 ;
//integer f_hndl_bla3 ;
integer f_hndl_b1_MATLAB ;
integer f_hndl_upper_alpha_in;
integer f_hndl_upper_beta_in;
integer f_hndl_upper_alpha_out;
integer f_hndl_upper_beta_out;
integer f_hndl_b1_ideal;
integer f_hndl_upper_output;
integer f_hndl_lower_output;
//integer f_hndl_lower_alpha_in;
//integer f_hndl_lower_beta_in;

// Task to open files and create file handlers to read data
task open_files;
string index_str;
begin
    f_bua1  = {"bua1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua2  = {"bua2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua3  = {"bua3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_upper_alpha_in = {"upper_alpha_in_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_upper_beta_in = {"upper_beta_in_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_b1_MATLAB = {"upper_b1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_upper_alpha_out = {"upper_alpha_out_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};
    f_upper_beta_out = {"upper_beta_out_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};
    f_b1_ideal = {"b1_ideal_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_upper_output = {"upper_output_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_lower_output = {"lower_output_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
//    f_bla1  = {"bla1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
//    f_bla2 = {"bla2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
//    f_bla3 = {"bla3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
//    f_lower_alpha_in = {"lower_alpha_in_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
//    f_lower_beta_in = {"lower_beta_in_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  

    f_hndl_bua1  = $fopen(f_bua1, "r"); 
    f_hndl_bua2  = $fopen(f_bua2, "r"); 
    f_hndl_bua3  = $fopen(f_bua3, "r");  
    f_hndl_upper_alpha_in  = $fopen(f_upper_alpha_in, "r"); 
    f_hndl_upper_beta_in  = $fopen(f_upper_beta_in, "r");   
    f_hndl_b1_MATLAB = $fopen(f_b1_MATLAB, "r"); 
    f_hndl_upper_alpha_out = $fopen(f_upper_alpha_out, "r");
    f_hndl_upper_beta_out = $fopen(f_upper_beta_out, "r");
    f_hndl_b1_ideal = $fopen(f_b1_ideal, "r"); 
    f_hndl_upper_output = $fopen(f_upper_output, "r"); 
    f_hndl_lower_output = $fopen(f_lower_output, "r"); 
    
//    f_hndl_bla1  = $fopen(f_bla1, "r"); 
//    f_hndl_bla2  = $fopen(f_bla2, "r"); 
//    f_hndl_bla3  = $fopen(f_bla3, "r"); 
//    f_hndl_lower_alpha_in  = $fopen(f_lower_alpha_in, "r");
//    f_hndl_lower_beta_in  = $fopen(f_upper_beta_in, "r");

    

    if (f_hndl_bua1 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_bua1);
        $finish;
    end
    else
        $display("Opening File %s",f_bua1); 
        
    if (f_hndl_bua2 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_bua2);
        $finish;
    end
    else
        $display("Opening File %s",f_bua2); 
        
    if (f_hndl_bua3 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_bua3);
        $finish;
    end
    else
        $display("Opening File %s",f_bua3); 
            

    if (f_hndl_upper_alpha_in == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_upper_alpha_in);
        $finish;
    end
    else
        $display("Opening File %s",f_upper_alpha_in); 
                    
    if (f_hndl_upper_beta_in == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_upper_beta_in);
        $finish;
    end
    else
        $display("Opening File %s",f_upper_beta_in); 
	if (f_hndl_b1_MATLAB == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_b1_MATLAB);
        $finish;
    end
    else
        $display("Opening File %s",f_b1_MATLAB); 
    if (f_hndl_upper_alpha_out == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_upper_alpha_out);
        $finish;
    end
    else
        $display("Opening File %s",f_upper_alpha_out); 
                    
    if (f_hndl_upper_beta_out == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_upper_beta_out);
        $finish;
    end
    else
        $display("Opening File %s",f_upper_beta_out); 


    if (f_hndl_b1_ideal == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_b1_ideal);
        $finish;
    end
    else
        $display("Opening File %s",f_b1_ideal); 

    if (f_hndl_upper_output == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_upper_output);
        $finish;
    end
    else
        $display("Opening File %s",f_upper_output); 

    if (f_hndl_lower_output == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_lower_output);
        $finish;
    end
    else
        $display("Opening File %s",f_lower_output); 

//    if (f_hndl_bla1 == 0)    // Check if file exists
//    begin
//        $display("**ERROR** File open failed %s",f_bla1);
//        $finish;
//    end
//    else
//        $display("Opening File %s",f_bla1); 
//  
//    if (f_hndl_bla2 == 0)    // Check if file exists
//    begin
//        $display("**ERROR** File open failed %s",f_bla2);
//        $finish;
//    end
//    else
//        $display("Opening File %s",f_bla2); 
//            
//    if (f_hndl_bla3 == 0)    // Check if file exists
//    begin
//        $display("**ERROR** File open failed %s",f_bla3);
//        $finish;
//    end
//    else
//        $display("Opening File %s",f_bla3); 
//              
//    if (f_hndl_lower_alpha_in == 0)    // Check if file exists
//    begin
//        $display("**ERROR** File open failed %s",f_lower_alpha_in);
//        $finish;
//    end
//    else
//        $display("Opening File %s",f_lower_alpha_in); 
//                               
//    if (f_hndl_lower_beta_in == 0)    // Check if file exists
//    begin
//        $display("**ERROR** File open failed %s",f_lower_beta_in);
//        $finish;
//    end
//    else
//        $display("Opening File %s",f_lower_beta_in); 
                                       
end
endtask
int bit_index = 0;
int iteration_index = 0;
int count;
int data;
initial
begin
    open_files();
        for(bit_index=0; bit_index<FrameLength+3; bit_index++)
            begin
                count = $fscanf(f_hndl_bua2,"%d ",data);
                bua2[bit_index] = $signed(data);
                count = $fscanf(f_hndl_bua3,"%d ",data);
                bua3[bit_index] = $signed(data);
		count = $fscanf(f_hndl_b1_ideal,"%d ",data);
                b1_ideal[bit_index] = $signed(data);
                //count = $fscanf(f_hndl_bla1,"%d ",data);
                //bla1_mem[bit_index] = $signed(data);
                //count = $fscanf(f_hndl_bla2,"%d ",data);
                //bla2_mem[bit_index] = $signed(data);
                //count = $fscanf(f_hndl_bla3,"%d ",data);
                //bla3_mem[bit_index] = $signed(data);	
	    end
	for(int iteration_index=1; iteration_index<=num_iteration; iteration_index++)
		begin
			for(bit_index=0; bit_index<FrameLength+3; bit_index++)
			begin
			count = $fscanf(f_hndl_bua1,"%d ",data);
           		bua1_mem[iteration_index][bit_index] = $signed(data);
//        		count = $fscanf(f_hndl_bla1,"%d ",data);
//        		bla1_mem[iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_upper_alpha_in,"%d ",data);
			upper_alpha_in_mem [iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_upper_beta_in,"%d ",data);
			upper_beta_in_mem [iteration_index][bit_index] = $signed(data);
			//count = $fscanf(f_hndl_lower_alpha_in,"%d ",data);
			//lower_alpha_in_mem [iteration_index][bit_index] = $signed(data);
			//count = $fscanf(f_hndl_lower_beta_in,"%d ",data);
			//lower_beta_in_mem [iteration_index][bit_index] = $signed(data);
          		count = $fscanf(f_hndl_b1_MATLAB,"%d ",data);
           		upper_be1_mem[iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_upper_alpha_out,"%d ",data);
			upper_alpha_out_mem_matlab [iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_upper_beta_out,"%d ",data);
			upper_beta_out_mem_matlab [iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_upper_output,"%d ",data);
			upper_output [iteration_index][bit_index] = $signed(data);
			count = $fscanf(f_hndl_lower_output,"%d ",data);
			lower_output [iteration_index][bit_index] = $signed(data);
		   	end
        end
	$display("Data input finished");
end

// Process to Clock data into FPTD
int DCs;
int errors;
int i,j;
int bit_index_in;
int loop;
int iteration_index_in;
initial
begin
	$display("Bus data started");
	for (iteration_index_in = 1; iteration_index_in<=num_iteration; iteration_index_in++)
	begin
		bit_index_in = 0;
		for(loop = 0;loop < 16;loop++)
		begin
			wait(Start2);
			$display("Start2");
			bua1 = bua1_mem[iteration_index_in];
			upper_alpha_in = upper_alpha_in_mem[iteration_index_in];
			upper_beta_in = upper_beta_in_mem[iteration_index_in];
			upper_be1 = upper_be1_mem[iteration_index_in];	
			for(int k=0; k<7; k++)		
			begin
				$display("bit_index_in",bit_index_in,"    ","iteration_index_in",iteration_index_in);
				if(bit_index_in>=FrameLength+3)
				begin
					break;
				end

				else
				begin
				for(i=0;i<M;i++)
				begin
					BusData[k][i] = bua1[bit_index_in][i];
				end

				for(i=0;i<N;i++)
				begin
					BusData[k][i+M] = bua2[bit_index_in][i];
				end

				for(i=0;i<N;i++)
				begin
					BusData[k][i+M+N] = bua3[bit_index_in][i];
				end

				for(i=0;i<35;i++)
				begin
					BusData[k][i+M+N+N] = upper_alpha_in[bit_index_in][i];
				end

				for(i=0;i<35;i++)
				begin
					BusData[k][i+M+N+N+35] = upper_beta_in[bit_index_in][i];
				end
					//b1_ideal
					BusData[k][M+N+N+70] = b1_ideal[bit_index_in];
					//nClear
					BusData[k][M+N+N+71] = 1;
					//Enable
					BusData[k][M+N+N+72] = enable_reg;
					bit_index_in = bit_index_in + 1;
				end
			end	
			wait(ASIC1.TestReady);
			$display("ASC1.TestReady");
        		wait(!ASIC1.TestReady);    
		end					
            
	end
    $fclose(f_hndl_bua1);
    $fclose(f_hndl_bua2);
    $fclose(f_hndl_bua3);
//    $fclose(f_hndl_blt1);
//    $fclose(f_hndl_bla2);
//    $fclose(f_hndl_bla3);
    $fclose(f_hndl_b1_MATLAB);
    $fclose(f_hndl_BER);
    $display("Close files");
    $display("DCs = %1.2f\tBER = %0d/%0d = %1.3e",DCs, errors, FrameLength, errors/FrameLength);
    $finish;
end

int loop_out;
int bit_index_out;
int iteration_index_out;
int index;
int a_out,b_out,c_out,x_out;

integer i_reg;
reg [N4-1:0] Reg1;
reg [N4-1:0] Reg2;
reg [N4-1:0] Reg3;
reg [N4-1:0] Reg4;
reg [N4-1:0] Reg5;
reg [N4-1:0] Reg6;
reg [N4-1:0] Reg7;

assign TOutData[0] = Reg1;
assign TOutData[1] = Reg2;
assign TOutData[2] = Reg3;
assign TOutData[3] = Reg4;
assign TOutData[4] = Reg5;
assign TOutData[5] = Reg6;
assign TOutData[6] = Reg7;

always @ (posedge Clock) begin 
	enable_reg <= ~enable_reg;
end

always @ (posedge Clock, negedge nReset) begin

	Outshift<=ASIC1.Outshift;
	Outkeep<=ASIC1.Outkeep;
//	wait(ASIC1.Outkeep);
	Reg1[0] <= TOut[0];
        Reg2[0] <= TOut[1];
        Reg3[0] <= TOut[2];
        Reg4[0] <= TOut[3];
        Reg5[0] <= TOut[4];
        Reg6[0] <= TOut[5];
	Reg7[0] <= TOut[6];
        for (i_reg=1; i_reg<N1; i_reg++)
        begin
    	    Reg1[i_reg] <= Reg1[i_reg-1];
            Reg2[i_reg] <= Reg2[i_reg-1];
            Reg3[i_reg] <= Reg3[i_reg-1];
            Reg4[i_reg] <= Reg4[i_reg-1];
            Reg5[i_reg] <= Reg5[i_reg-1];
            Reg6[i_reg] <= Reg6[i_reg-1];
       	    Reg7[i_reg] <= Reg7[i_reg-1];
        end
//	wait(ASIC1.Outshift);
//        wait(!ASIC1.Outshift); 
end


/*initial
begin
	wait(ASIC1.Outshift);
		TOutData[0][x_out] = TOut[0];
		TOutData[1][x_out] = TOut[1];
		TOutData[2][x_out] = TOut[2];
		TOutData[3][x_out] = TOut[3];
		TOutData[4][x_out] = TOut[4];
		TOutData[5][x_out] = TOut[5];
		TOutData[6][x_out] = TOut[6];
	wait(ASIC1.Outkeep);
	wait(!ASIC1.Outkeep);
end*/
// Extract output data by the order alpha_out, beta_out, extrinsic, error
initial
begin
	for (iteration_index_out = 0; iteration_index_out <= num_iteration; iteration_index_out++)
	begin
		bit_index_out = 0;
		for (loop_out = 0;loop_out < 16; loop_out++)
		begin
			wait(ASIC1.Outkeep);
	 		$display("OutKeep");
			for (int k_out=0;k_out<7;k_out++)
			begin
				$display("bit_index_out",bit_index_out,"    ","iteration_index_out",iteration_index_out);
				if (bit_index_out >= FrameLength+3)
				begin
					break;
				end
				
				else
				begin
					for (index=0;index<35;index++)
					begin
						upper_alpha_out[bit_index_out][index] = TOutData[k_out][index];
					end
					for (index=0;index<35;index++)
					begin
						upper_beta_out[bit_index_out][index] = TOutData[k_out][35+index];
					end
					for (index=0;index<M;index++)
					begin
						upper_result[bit_index_out][index] = TOutData[k_out][70+index];
					end
					upper_error[iteration_index_out][bit_index_out] = TOutData[k_out][75]; 
					bit_index_out = bit_index_out + 1;
				end
			end
			wait(ASIC1.Outshift);
        		wait(!ASIC1.Outshift); 
			$display("OutShift = 0");   
		end
		upper_alpha_out_mem[iteration_index_out] = upper_alpha_out;
		upper_beta_out_mem[iteration_index_out] = upper_beta_out;
		upper_result_mem[iteration_index_out] = upper_result;
	end
end

typedef enum logic[2:0] {IDLE, LOAD_LLRS, DECODE, EARLY_STOP, MAX_DCs, FINISH} state_enum;

logic finished1; 
logic finished2; 
string f_BER;
integer f_hndl_BER ;

        
initial 
begin
    finished1 = 0; 
    finished2 = 0; 
    DCs = 0;
    errors = 0;
    f_BER  = {"Results_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_hndl_BER  = $fopen(f_BER, "w"); 
    if (f_hndl_BER == 0)    // Check if file exists
        begin
            $display("**ERROR** File open failed %s",f_BER);
            $finish;
        end
        else
            $display("Opening File %s",f_BER); 
end

int a, b, c, d, e, f;

always@(posedge Clock)
begin
    if(ASIC1.FPTD1.Control.state == EARLY_STOP && !finished1)
    begin
        finished1 = 1;
        DCs = DCs + ASIC1.FPTD1.Control.DC;
        errors = errors + ASIC1.FPTD1.Errors;
        $display("FPTD1: DC = %0d\t Errors = %0d",ASIC1.FPTD1.Control.DC, ASIC1.FPTD1.Errors);
        $fwrite(f_hndl_BER, "FPTD1: %0d %0d \n",ASIC1.FPTD1.Control.DC, ASIC1.FPTD1.Errors);
    end
//FPTD2 is for pipe_razor_mode
    // if(ASIC1.FPTD2.Control.state == EARLY_STOP && !finished2)
    // begin
	// finished2 = 1;
	// $display("FPTD2: DC = %0d\t Errors = %0d",ASIC1.FPTD2.Control.DC, ASIC1.FPTD2.Errors);
	// $fwrite(f_hndl_BER, "FPTD2: %0d %0d \n",ASIC1.FPTD2.Control.DC, ASIC1.FPTD2.Errors);
    // end
    //if(ASIC1.FPTD1.Control.state == FINISH && !finished)
    if(ASIC1.FPTD1.Control.state == MAX_DCs && !finished1)
    begin
        finished1 = 1;
        DCs = DCs + DCmax-1;
        errors = errors + ASIC1.FPTD1.Errors;
        $display("FPTD1: DC = %0d\t Errors = %0d",DCmax-1, ASIC1.FPTD1.Errors);
        $fwrite(f_hndl_BER, "FPTD1: %0d %0d \n",DCmax-1, ASIC1.FPTD1.Errors);
    end
    // if(ASIC1.FPTD2.Control.state == MAX_DCs && !finished2)
    // begin
	// finished2 = 1;
	// $display("FPTD2: DC = %0d\t Errors = %0d",DCmax-1, ASIC1.FPTD2.Errors);
	// $fwrite(f_hndl_BER, "FPTD2: %0d %0d \n",DCmax-1, ASIC1.FPTD2.Errors);
    // end
    if(ASIC1.FPTD1.Control.state == IDLE)
    begin
        finished1 = 0;
    end
    // if(ASIC1.FPTD2.Control.state == IDLE)
    // begin
	// finished2 = 0;
    // end
	if(ASIC1.FPTD1.Control.state == MAX_DCs || ASIC1.SysControl1.state1 == 3)
    begin
//	$display("Comparison Started.");
	if (upper_result == upper_be1)
			a=1;
		else
			a=0;

//        if (ASIC1.b1_ideal == b1_MATLAB)
//			a=1;
//		else
//			a=0;
//		if (ASIC1.bua1 == bua1)
//			b=1;
//		else
//			b=0;
//		if (ASIC1.bua2 == bua2)
//			c=1;
//		else
//			c=0;
//		if (ASIC1.bua3 == bua3)
//			d=1;
//		else
//			d=0;
//		if (ASIC1.blt1 == blt1)
//			e=1;
//		else
//			e=0;
//		if (ASIC1.bla2 == bla2)
//			f=1;
//		else
//			f=0;
    end
end
endmodule
