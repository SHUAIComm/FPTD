
`timescale 1ns/1ps
module tb_Section_Razor;
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
//logic nClear;
logic Enable;
//logic b1_ideal;
logic signed [M-1:0] ba1_DFF;
logic signed [N-1:0] ba2;
logic signed [N-1:0] ba3;
logic signed [7:1][M-1:0] alpha_in_DFF;
logic signed [7:1][M-1:0] beta_in_DFF;
logic Error_previous_Alpha;
logic Error_previous_Beta;
logic Error_previous_be1;

//output
logic signed [7:1][M-1:0] alpha_out_DFF;
logic signed [7:1][M-1:0] beta_out_DFF;
logic signed [M-1:0] be1_DFF;
logic Error_current_Alpha;
logic Error_current_Beta;
logic Error_current_be1;
//logic b1_error;

				  
Section_razor1 # (.N(N), .M(M))
u_section       (.Clock(Clock),
                 .nReset(nReset),
//                 .nClear(nClear),
                 .Enable(Enable),
                 .ba1_DFF(ba1_DFF),
                 .ba2(ba2),
                 .ba3(ba3),
                 .alpha_in_DFF(alpha_in_DFF), 
                 .beta_in_DFF(beta_in_DFF),
		 .Error_previous_Alpha(Error_previous_Alpha),
		 .Error_previous_Beta(Error_previous_Beta),
		 .Error_previous_be1(Error_previous_be1),
                 .alpha_out_DFF(alpha_out_DFF),
                 .beta_out_DFF(beta_out_DFF),
		.Error_current_Alpha(Error_current_Alpha),
		.Error_current_Beta(Error_current_Beta),
		.Error_current_be1(Error_current_be1),
                 .be1_DFF(be1_DFF));
                              
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
//    nClear = 1;
    Enable = 1;
	Error_previous_Alpha = 0;
        Error_previous_Beta = 0;
        Error_previous_be1 = 0;
   // b1_ideal =1 ;
	
	//put your data from matlab into here******************
    ba1_DFF = 2;
    ba2 = 5;
    ba3 = 5;
    alpha_in_DFF = '{1,11,-10,8,11,-7,-15};
    beta_in_DFF = '{0,-16,8,2,7,-7,7};
	//put your data from matlab into here******************
	
	//*****************************************************************
	//the commented section in this file can be modified to read .txt 
	//file from matlab, you can play with it to read your output files 
	//so that you don't need to change input values manually
    //*****************************************************************
	
wait(nReset);
	#(3.2*TCLK);
	Enable = 0;
	Error_previous_Alpha = 0;
        Error_previous_Beta = 0;
        Error_previous_be1 = 0;
//	nClear = 1;
	#(5*TCLK);
	Enable = 1;
	Error_previous_Alpha = 1;
        Error_previous_Beta = 1;
        Error_previous_be1 = 1;
//	nClear = 0;
	#(5*TCLK);
	Enable = 0;
	Error_previous_Alpha = 1;
        Error_previous_Beta = 1;
        Error_previous_be1 = 1;
//	nClear = 1;
	#(5*TCLK);
	Enable = 1;
//	nClear = 0;
	#(5*TCLK);
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