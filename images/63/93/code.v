module top_module(clock, res, resetn, wins);input res;
	input clock;
	input resetn;
	output [2:0]wins;
	
	reg curr_wins; 
	
	localparam A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101, G = 3'b110, H = 3'b111;
	reg [2:0] curr, next; 
	
	always@(*)
	begin: state_table
		case(curr)
			A: begin
				if (res) next <= B;
				else next <= A;
				end
			B: begin
				if (res) next <= D;
				else next <= C;
				end
			C: begin
				if (res) next <= F;
				else next <= E;
				end
			D: begin
				if (res) next <= H;
				else next <= G;
				end
			E: begin
				if (res) next <= B;
				else next <= A;
				end
			F: begin
				if (res) next <= D;
				else next <= C;
				end
			G: begin
				if (res) next <= F;
				else next <= E;
				end
			H: begin
				if (res) next <= H;
				else next <= G;
				end
		endcase
	end
	
	
	always @(posedge clock)
	begin: state_FFs
		if (resetn == 1'b0)
			curr <= A;
		else
			curr = next;
	end

	assign wins[2:0] = next[2:0];endmodule