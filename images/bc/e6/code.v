module top_module(in, clock, reset, out);input in;
	input clock;
	input reset;
	output [1:0]out;

	localparam A = 2'b00, B = 2'b01, C = 2'b10, D = 2'b11;	
	reg [1:0] curr, next; 

	always @(*)
	begin: state_table
		case(curr)
			A: begin
				if (!in) next <= A;
				else next <= B;
				end
			B: begin
				if (!in) next <= A;
				else next <= C;
				end
			C: begin
				if (!in) next <= A;
				else next <= D;
				end
			D: begin
				if (!in) next <= A;
				else next <= D;
				end
			default: next = A;
		endcase
	end

	
	always @(posedge clock)
	begin: state_FFs
		if(reset == 1'b0)
			curr <= A;
		else
			curr = next;
	end

	assign out[1:0] = next;endmodule