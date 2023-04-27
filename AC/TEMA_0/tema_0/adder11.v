`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:52:54 11/08/2022 
// Design Name: 
// Module Name:    adder11 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module half_adder(
    output sum,
    output c_out,  
    input  a,
    input  b);
	 
	 xor X1 (sum,a,b);
	 and A1 (c_out,a,b);
endmodule

module full_adder(
    output sum,
    output c_out,   
    input  a,
    input  b,
    input  c_in);    
    
	 half_adder h1 (s1, c1, a, b);
	 half_adder h2 (sum, c2, c_in, s1);
	 or (c_out,c1,c2);
endmodule

module adder11(
	output [11:0] sum,
   	output c_out,	     
   	input  [10:0] a,
	input  [10:0] b);     
	
	full_adder ADD1 (sum[0], c_in1,a[0],b[0],'b0);
	full_adder ADD2 (sum[1], c_in2,a[1],b[1],c_in1);
	full_adder ADD3 (sum[2], c_in3,a[2],b[2],c_in2);
	full_adder ADD4 (sum[3], c_in4,a[3],b[3],c_in3);
	full_adder ADD5 (sum[4], c_in5,a[4],b[4],c_in4);
	full_adder ADD6 (sum[5], c_in6,a[5],b[5],c_in5);
	full_adder ADD7 (sum[6], c_in7,a[6],b[6],c_in6);
	full_adder ADD8 (sum[7], c_in8,a[7],b[7],c_in7);
	full_adder ADD9 (sum[8], c_in9,a[8],b[8],c_in8);
	full_adder ADD10 (sum[9], c_in10,a[9],b[9],c_in9);
	full_adder ADD11 (sum[10], sum[11],a[10],b[10],c_in10);
endmodule
