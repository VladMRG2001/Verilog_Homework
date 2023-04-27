`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:48:55 11/25/2022
// Design Name:   div_algo
// Module Name:   C:/Users/Vlad/Desktop/UPB/SEM V/AC/TEME/tema1/test_divalgo.v
// Project Name:  tema1
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: div_algo
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_divalgo;

	// Inputs
	reg [15:0] N;
	reg [15:0] D;

	// Outputs
	wire [15:0] Q;
	wire [15:0] R;

	// Instantiate the Unit Under Test (UUT)
	div_algo uut (
		.Q(Q), 
		.R(R), 
		.N(N), 
		.D(D)
	);

	initial begin
		// Initialize Inputs
		N = 0;
		D = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		N=100;
		D=3;
		
		#100;
		N = 9995;
		D = 23;
		//
		#100;
		N = 354;
		D = 56;
		
	end
      
endmodule

