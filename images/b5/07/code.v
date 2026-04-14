module top_module(SW, KEY, LEDR);input [9:0] SW;
	input [3:0] KEY;
	output [9:0] LEDR;
	
	wire w, clock, reset, z;
	
	reg [2:0] y_Q, Y_D; 
	
	localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110;
	
	
	assign w = SW[1];
	assign clock = KEY[0];
	assign reset = SW[0];
	assign LEDR[9] = z;
	assign LEDR[2:0] = y_Q;
	
	
	always @(*)
	begin 
		case (y_Q)
			A: begin
					if (!w) Y_D = A;
					else Y_D = B;
				end
			B: begin
					if (!w) Y_D = A;
					else Y_D = C;
				end
			C: begin
					if (!w) Y_D = E;
					else Y_D = D;
				end
			D: begin
					if (!w) Y_D = E;
					else Y_D = F;
				end
			E: begin
					if (!w) Y_D = A;
					else Y_D = G;
				end
			F: begin
					if (!w) Y_D = E;
					else Y_D = F;
				end
			G: begin
					if (!w) Y_D = A;
					else Y_D = C;
				end
			default: Y_D = A;
		endcase
	end
	
	
	always @(posedge clock)
	begin		
		if (reset == 1'b0)
			y_Q = A;
		else
			y_Q = Y_D;
	end		
	
	
	
	assign z = ((y_Q == F) || (y_Q == G));
endmodule