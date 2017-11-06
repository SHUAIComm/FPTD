`timescale 1ns/1ps
module tb_Section;
parameter N = 4; 
parameter M = 5;
parameter Eb_N0 = 0.0;
parameter FrameLength = 104;
parameter TCLK = 100;
//parameter num_TCLK = 256; 
parameter num_TCLK = 100; 
parameter num_frames = 10000;
parameter DCmax=100;
logic Clock;
logic nReset;

//input
logic nClear;
logic Enable;
logic b1_ideal;
logic signed [M-1:0] ba1;
logic signed [N-1:0] ba2;
logic signed [N-1:0] ba3;
logic signed [7:1][M-1:0] alpha_in;
logic signed [7:1][M-1:0] beta_in;

//output
logic signed [7:1][M-1:0] alpha_out;
logic signed [7:1][M-1:0] beta_out;
logic signed [M-1:0] be1;
logic b1_error;

				  
Section # (.N(4), .M(5))
u_section       (.Clock(Clock),
                 .nReset(nReset),
                 .nClear(nClear),
                 .Enable(Enable),
                 .b1_ideal(b1_ideal),
                 .ba1(ba1),
                 .ba2(ba2),
                 .ba3(ba3),
                 .alpha_in(alpha_in), 
                 .beta_in(beta_in),
                 .alpha_out(alpha_out),
                 .beta_out(beta_out),
                 .be1(be1),
                 .b1_error(b1_error));
                              
// Clock process
always
begin
    Clock = 1'b0;
    #(0.5*TCLK);
    Clock = 1'b1;
    #(0.5*TCLK);
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

initial
begin
    nClear = 0;
    Enable = 0;
    b1_ideal = 0;
	
	//put your data from matlab into here******************
    ba1 = -10;
    ba2 = 12;
    ba3 = 2;
    alpha_in = '{9,-4,1,8,-4,15,-2};
    beta_in = '{1,-2,6,-16,12,10,-8};
	//put your data from matlab into here******************
	
	//*****************************************************************
	//the commented section in this file can be modified to read .txt 
	//file from matlab, you can play with it to read your output files 
	//so that you don't need to change input values manually
    //*****************************************************************
	
	wait(nReset);
	#(3.2*TCLK);
	Enable = 1;
	nClear = 1;
	#(5*TCLK);
	Enable = 1;
	nClear = 0;
	#(5*TCLK);
	Enable = 0;
	nClear = 1;
	#(5*TCLK);
	Enable = 0;
	nClear = 0;
	$stop;
end

/*
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
    f_but1  = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/but1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua2  = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/bua2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"}; 
    f_bua3  = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/bua3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_blt1 = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/blt1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_bla2 = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/bla2_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_bla3 = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/bla3_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    f_b1_MATLAB = {"/home/sz3a12/ECSserver/FPTD_v04/behave_sim/b1_", FrameLength_str, "_", N_str, "N", M_str, "M_", Eb_N0_str, "dB.txt"};  
    
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
*/

endmodule
