`timescale 1ns / 1ps

module process (
        input                clk,		    	// clock 
        input  [23:0]        in_pix,	        // valoarea pixelului de pe pozitia [in_row, in_col] din imaginea de intrare (R 23:16; G 15:8; B 7:0)
        input  [8*512-1:0]   hiding_string,     // sirul care trebuie codat
        output [6-1:0]       row, col, 	        // selecteaza un rand si o coloana din imagine
        output               out_we, 		    // activeaza scrierea pentru imaginea de iesire (write enable)
        output [23:0]        out_pix,	        // valoarea pixelului care va fi scrisa in imaginea de iesire pe pozitia [out_row, out_col] (R 23:16; G 15:8; B 7:0)
        output               gray_done,		    // semnaleaza terminarea actiunii de transformare in grayscale (activ pe 1)
        output               compress_done,		// semnaleaza terminarea actiunii de compresie (activ pe 1)
        output               encode_done        // semnaleaza terminarea actiunii de codare (activ pe 1)
    );	
    
	 reg[2:0] state;
	 reg[2:0] next_state;
	 reg[6-1:0] row_reg;
	 reg[6-1:0] next_row_reg;
	 reg[6-1:0] col_reg;
	 reg[6-1:0] next_col_reg;
	 reg out_we_reg = 0;
	 reg[23:0] out_pix_reg;
	 reg gray_done_reg = 0;
	 reg[7:0] minim, maxim;
	 
	 //assign-uri pt output-uri
	 assign gray_done = gray_done_reg;
	 assign out_we = out_we_reg;
	 assign out_pix = out_pix_reg;
	 assign row = row_reg;
	 assign col = col_reg;
	 
    //TODO - instantiate base2_to_base3 here
	 parameter width = 16;
    base2_to_base3 #(width) Algoritm (.base3_no(base3_no), .done(done), .base2_no(base2_no), .en(en), .clk(clk));
	 
    //TODO - build your FSM here
	 
    //definirea celor 3 stari ale FSM-ului
	`define START  0        
	`define FIND_YELLOW  1
	`define END_GRAYSCALE 2 

    //partea secventiala
    always@(posedge clk) begin
			state <= next_state;
			col_reg <= next_col_reg;
			row_reg <= next_row_reg;
	 end
	 
	 //partea combinationala
	 always@(*)begin	
			case(state)
			
			`START: begin
				out_we_reg = 0;
				minim = 255;
				maxim = 0;
				next_state = 1;
			end
			
			`FIND_YELLOW: begin
				if(in_pix[23:16] > maxim) begin
					maxim = in_pix[23:16];
				end
				if(in_pix[23:16] < minim) begin
					minim = in_pix[23:16];
				end
				if(in_pix[15:8] > maxim) begin
					maxim = in_pix[15:8];
				end
				if(in_pix[15:8] < minim) begin
					minim = in_pix[15:8];
				end
				if(in_pix[7:0] > maxim) begin
					maxim = in_pix[7:0];
				end
				if(in_pix[7:0] < minim) begin
					minim = in_pix[7:0];
				end

				out_pix_reg[7:0] = 0;
				out_pix_reg[15:8] = (minim+maxim)/2;
				out_pix_reg[23:16] = 0;

				out_we_reg = 1;
				next_state = 2;
			end
	
			`END_GRAYSCALE: begin
				if(row_reg == 63 && col_reg == 63) begin
					gray_done_reg = 1;
				end 
				
				if(row_reg == 63)begin
					if(col_reg != 63)begin
						next_state = 0;
					end	
					next_col_reg = col_reg + 1;	
				end 
				
				if(row_reg != 63) begin
					next_state = 0;
				end
				
				next_row_reg = row_reg + 1;
			end
			
			default: begin
				next_state = 0; 
				next_col_reg = 0; 
				next_row_reg = 0;
			end
			
			endcase
	 end
	 
endmodule
