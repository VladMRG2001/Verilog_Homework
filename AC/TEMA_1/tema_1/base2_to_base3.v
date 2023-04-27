`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:48 11/25/2022 
// Design Name: 
// Module Name:    base2_to_base3 
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
module base2_to_base3 (
	output   [31 : 0]  base3_no, 
	output             done,
	input    [15 : 0]  base2_no,
   input              en,
   input              clk);
	
	//iesirile din div_algo
	wire [15:0] Q; 
	wire [15:0] R;

	reg [2:0] state, next_state; //ajung 3 biti pt a reprezenta starile (0-3)
	reg [0:0] done_reg;
	reg [15:0] base2_no_r; 
	reg [15:0] noul_deimpartit; //base2_intermediar
	reg [31:0] base3_no_r;	
	reg [4:0] width; //cele 32 de pozitii ale lui base3_no - pe 5 biti
	//pe ele retin restul dupa fiecare executare a div_algo
	
	//assign pt iesiri
	assign base3_no = base3_no_r;
	assign done = done_reg;

	//definirea celor 4 stari ale FSM-ului
	`define read  0        
	`define exec  1
	`define exec2 2
	`define done  3      
	
	//partea secventiala a FSM-ului
	always @(posedge clk) begin
		state <= next_state;
	end
	
	//instantierea modulului div_algo 
	div_algo ALG(Q, R, noul_deimpartit, 3); 
	
	//partea combinationala a FSM-ului
	always @(*) begin
		case (state)
		`read: begin
				done_reg = 0; //done e initial 0
				base3_no_r = 0; //nr in baza 3 e initial 0
				width = 0; //pozitia in base3_no_r e initial 0
			if(en == 1) begin
				base2_no_r = base2_no; //citirea input-ului in base2_no_r
				next_state = `exec; //apoi se trece mai departe
			end
		end
			
		`exec: begin
				noul_deimpartit = base2_no_r; //val noua pt fiecare apelare a lui div_algo
				next_state = `exec2; 
		end
			
		`exec2: begin
		//iau ambii biti ai restului si ii copiez in numarul in baza 3
				base3_no_r[width] = R[0]; 
				base3_no_r[width+1] = R[1]; 
				base2_no_r = Q; //catul devine noul deimpartit
				
			if(base2_no_r == 0) begin 
				next_state = `done; //daca nu mai am ce imparti -> gata
			end 
			else begin
				next_state = `exec; //altfel, impart iar
				width = width + 2; //si ocup urmatorii 2 biti din base3_n0_r cu restul
			end
		end
			
		`done: begin
				done_reg = 1; //am convertit numarul si done devine 1
				next_state = `read; //se citeste urmatorul numarul in baza 2
		end
			
		default: next_state = `read; //starea initiala
		endcase
	end
	
endmodule
