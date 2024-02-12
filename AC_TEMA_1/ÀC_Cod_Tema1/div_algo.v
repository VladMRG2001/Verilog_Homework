`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:46:37 11/25/2022 
// Design Name: 
// Module Name:    div_algo 
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
module div_algo(
   output [15:0] Q,
	output [15:0] R,
	input  [15:0] N,
	input  [15:0] D);
	
	//Algoritmul folosit este "Integer division (unsigned) with remainder"
	//Alegerea este motivata in README
	
	//Declararea variabilelor de tip reg pt a putea lua valori
	reg [3:0] i; //pe 4 biti, deoarece are valori de la 1 la 15<(2^4)
	reg [15:0] Q_reg;
	reg [15:0] R_reg;
	
	always @(*) begin
	
	//Daca impartitorul este 0, afisez mesaj de eroare
	if(D==0)
		begin 
			$display("Eroare: Nu se poate imparti la 0");
		end
		
	//Initializare Q si R cu 0 conform algoritmului
	Q_reg=0;
	R_reg=0;
	
	for(i=15; i>0; i=i-1) //i==n-1, unde n este nr de biti din N
		begin
			R_reg=R_reg<<1; //R_reg se shifteaza la stanga cu un bit
			R_reg[0]=N[i]; //Setez ca LSB al lui R sa fie egal cu bitul i al lui N
			
			if(R_reg >= D)
				begin
					R_reg=R_reg-D;
					Q_reg[i]=1;
				end
		end //end pt for
	
	//">=0" in interiorul "for" rezulta in failed to synthesize
	//">-1" rezulta in rulare, dar rezultatele nu sunt bune
	
	// astfel, am decis sa fac un caz separat pt i==0
	if (i==0)
		begin
			R_reg=R_reg<<1;
			R_reg[0]=N[i];
			
			if(R_reg >= D)
				begin
					R_reg=R_reg-D;
					Q_reg[i]=1;
				end
		end //end pt cazul special

	end //end pt blocul always combinational
	
	assign Q = Q_reg;
	assign R = R_reg;

endmodule
