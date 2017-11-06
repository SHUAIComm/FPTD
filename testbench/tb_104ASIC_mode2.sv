`timescale 1ns/1ps
module tb_ASIC2;
parameter N1 = 200;
parameter N2 = 7;
parameter N3 = 84;
parameter N4 = 76;
parameter FL = 104;
parameter N = 4; 
parameter M = 5;
parameter Eb_N0 = 0.0;
parameter FrameLength = 104;
parameter TCLK = 100;
parameter num_TCLK = 100; 
parameter num_frames = 10000;
parameter DCmax=200;
logic Clock;
logic nReset;
logic Enable_Odd;
logic Enable_Even;
logic Enable_Term;
logic Enable_Error_Counter;

// Input LLRs
// Upper decoder
logic signed [2:0][N-1:0] but1;
logic signed [num_frames:1][2:0][N-1:0] but1_mem;
logic signed [FrameLength+2:0][N-1:0] bua2; 
logic signed [num_frames:1][FrameLength+2:0][N-1:0] bua2_mem; 
logic signed [FrameLength-1:0][N-1:0] bua3;
logic signed [num_frames:1][FrameLength-1:0][N-1:0] bua3_mem;
// Lower decoder
logic signed [2:0][N-1:0] blt1;
logic signed [num_frames:1][2:0][N-1:0] blt1_mem;
logic signed [FrameLength+2:0][N-1:0] bla2;
logic signed [num_frames:1][FrameLength+2:0][N-1:0] bla2_mem;
logic signed [FrameLength-1:0][N-1:0] bla3; 
logic signed [num_frames:1][FrameLength-1:0][N-1:0] bla3_mem; 

logic signed [N2-1:0][N1-1:0] BusData;
logic signed [N2-1:0] In;
logic signed [N2-1:0] DOut1;
logic signed [N2-1:0] DOut2;
logic signed [6:0] TOut;
logic Mode;
logic Enable_f;
logic Sel_f;
logic S1;
logic S2;
logic S3;
logic Dclk;
logic Go;
logic bitout1;
logic bitout2;
logic KeepShift;
logic Start;
logic Start2;

// Output bits
logic [num_frames:1][FrameLength-1:0] b1_MATLAB_mem;
logic [FrameLength-1:0] b1_MATLAB ;
logic unsigned [6:0] Errors ;


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
//if (!ASIC1.FPTD1.Start || (!Start2 && !Mode))
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
    but1 = 0;
    bua2 = 0;
    bua3 = 0;
    blt1 = 0;
    bla2 = 0;
    bla3 = 0;
    b1_MATLAB = 0;
	BusData = 0;
	Mode = 0;
	Enable_f = 0;
	Sel_f = 0;
	S1 = 0;
	S2 = 0;
	S3 = 0;
	Go = 0;
    wait(nReset);
    //forever
    //begin
        #(3.2*TCLK);
        Go = 1;
        //wait(ASIC1.FPTD1.Ready);
        //wait(!ASIC1.FPTD1.Ready);
		//$stop;
    //end 
    #2000us
    $finish;
end

always
begin
	#200us
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
string f_but1;
string f_bua2;
string f_bua3;
string f_blt1;
string f_bla2;
string f_bla3;
string f_b1_MATLAB;
// File handlers
integer f_hndl_but1 ;
integer f_hndl_bua2 ;
integer f_hndl_bua3 ;
integer f_hndl_blt1 ;
integer f_hndl_bla2 ;
integer f_hndl_bla3 ;
integer f_hndl_b1_MATLAB ;

// Task to open files and create file handlers to read data
task open_files;
string index_str;
begin
    f_but1  = {"../data/but1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua2  = {"../data/bua2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua3  = {"../data/bua3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_blt1 = {"../data/blt1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_bla2 = {"../data/bla2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_bla3 = {"../data/bla3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_b1_MATLAB = {"../data/b1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    
    f_hndl_but1  = $fopen(f_but1, "r"); 
    f_hndl_bua2  = $fopen(f_bua2, "r"); 
    f_hndl_bua3  = $fopen(f_bua3, "r");    
    f_hndl_blt1  = $fopen(f_blt1, "r"); 
    f_hndl_bla2  = $fopen(f_bla2, "r"); 
    f_hndl_bla3  = $fopen(f_bla3, "r"); 
    f_hndl_b1_MATLAB = $fopen(f_b1_MATLAB, "r"); 
    
    if (f_hndl_but1 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_but1);
        $finish;
    end
    else
        $display("Opening File %s",f_but1); 
        
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
        
    if (f_hndl_blt1 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_blt1);
        $finish;
    end
    else
        $display("Opening File %s",f_blt1);  
        
    if (f_hndl_bla2 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_bla2);
        $finish;
    end
    else
        $display("Opening File %s",f_bla2); 
            
    if (f_hndl_bla3 == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_bla3);
        $finish;
    end
    else
        $display("Opening File %s",f_bla3); 
                
    if (f_hndl_b1_MATLAB == 0)    // Check if file exists
    begin
        $display("**ERROR** File open failed %s",f_b1_MATLAB);
        $finish;
    end
    else
        $display("Opening File %s",f_b1_MATLAB); 
     
end
endtask

int count;
int data;
initial
begin
    open_files();
    for(int frame_index=1; frame_index<=num_frames; frame_index++)
        begin
        for(int bit_index=0; bit_index<3; bit_index++)
            begin
                count = $fscanf(f_hndl_but1,"%d ",data);
                but1_mem[frame_index][bit_index] = $signed(data);
                count = $fscanf(f_hndl_blt1,"%d ",data);
                blt1_mem[frame_index][bit_index] = $signed(data);
            end
        for(int bit_index=0; bit_index<FrameLength+3; bit_index++)
            begin
                count = $fscanf(f_hndl_bua2,"%d ",data);
                bua2_mem[frame_index][bit_index] = $signed(data);
                count = $fscanf(f_hndl_bua3,"%d ",data);
                bua3_mem[frame_index][bit_index] = $signed(data);
                count = $fscanf(f_hndl_bla2,"%d ",data);
                bla2_mem[frame_index][bit_index] = $signed(data);
                count = $fscanf(f_hndl_bla3,"%d ",data);
                bla3_mem[frame_index][bit_index] = $signed(data);
                count = $fscanf(f_hndl_b1_MATLAB,"%d ",data);
                b1_MATLAB_mem[frame_index][bit_index] = $signed(data);
            end
        end
end
// Process to Clock data into FPTD
int DCs;
int errors;
int i,j;
initial
begin
    for(int frame_index=1; frame_index<=num_frames; frame_index++)
    begin
        //wait(ASIC1.FPTD1.Start)
        wait(Start2)
        but1 = but1_mem[frame_index];
        blt1 = blt1_mem[frame_index];
        bua2 = bua2_mem[frame_index];
        bua3 = bua3_mem[frame_index];
        bla2 = bla2_mem[frame_index];
        bla3 = bla3_mem[frame_index];
        b1_MATLAB = b1_MATLAB_mem[frame_index];
		
		
for (i=0;i<3;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[0][N*(i)+j] = but1[i][j];
	end
end

for (i=0;i<47;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[0][N*(i+3)+j] = bua2[i][j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[1][N*(i)+j] = bua2[i+47][j];
	end
end

for (i=0;i<FL+3-97;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[2][N*(i)+j] = bua2[i+97][j];
	end
end

for (i=0;i<50-(FL+3-97);i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[2][N*(i+FL+3-97)+j] = bua3[i][j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[3][N*(i)+j] = bua3[i+50-(FL+3-97)][j];
	end
end

//FL-(50+50-(FL+3-97))=FL+FL-194
for (i=0;i<FL+FL-194;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[4][N*(i)+j] = bua3[i+194-FL][j];
	end
end

for (i=0;i<3;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[4][N*(i+FL+FL-194)+j] = blt1[i][j];
	end
end

for (i=0;i<50-(FL+FL-194+3);i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[4][N*(i+FL+FL-194+3)+j] = bla2[i][j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[5][N*(i)+j] = bla2[i+50-(FL+FL-194+3)][j];
	end
end

//50-(FL+FL-194+3)+50=291-FL-FL
//FL+3-(291-FL-FL)=3*FL-288
for (i=0;i<3*FL-288;i++)
begin
	for (j=0;j<4;j++)
	begin
	BusData[6][N*(i)+j] = bla2[i+291-FL-FL][j];
	end
end

for (j=0;j<FL;j++)
begin
BusData[6][N*(3*FL-288)+j] = b1_MATLAB[j];
end
		
		
        //wait(ASIC1.FPTD1.Ready);
		//wait(!ASIC1.FPTD1.Ready);       
		wait(ASIC1.TestReady);
		wait(!ASIC1.TestReady);     
    end
    $fclose(f_hndl_but1);
    $fclose(f_hndl_bua2);
    $fclose(f_hndl_bua3);
    $fclose(f_hndl_blt1);
    $fclose(f_hndl_bla2);
    $fclose(f_hndl_bla3);
    $fclose(f_hndl_b1_MATLAB);
    $fclose(f_hndl_BER);
    $display("DCs = %1.2f\tBER = %0d/%0d = %1.3e",DCs/num_frames, errors, num_frames*FrameLength, errors/(num_frames*FrameLength));
    $finish;
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
    f_BER  = {"../data/Results_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
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
        if (ASIC1.b1_ideal == b1_MATLAB)
			a=1;
		else
			a=0;
		if (ASIC1.but1 == but1)
			b=1;
		else
			b=0;
		if (ASIC1.bua2 == bua2)
			c=1;
		else
			c=0;
		if (ASIC1.bua3 == bua3)
			d=1;
		else
			d=0;
		if (ASIC1.blt1 == blt1)
			e=1;
		else
			e=0;
		if (ASIC1.bla2 == bla2)
			f=1;
		else
			f=0;
    end
end
endmodule

// logic [FL-1:0] b1_ideal;
// logic signed [2:0][N-1:0] but1; 
// logic signed [FL+2:0][N-1:0] bua2; 
// logic signed [FL-1:0][N-1:0] bua3; 
// logic signed [2:0][N-1:0] blt1; 
// logic signed [FL+2:0][N-1:0] bla2; 
