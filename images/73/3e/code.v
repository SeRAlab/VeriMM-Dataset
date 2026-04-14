module top_module(
		input		[3:0]	ctl,
		input		[31:0]	a, b,
		output reg	[31:0]	out,
		output				zero );wire [31:0] sub_ab;
	wire [31:0] add_ab;

	always @(*) begin
		case (ctl)
			4'b0000:  out = a & b;				
			4'b0001:  out = a | b;				
			4'b0010:  out = a + b;				
			4'b0110:  out = a - b;				
	        4'b0111:  out = (a < b) ? 32'b00000000000000000000000000000001 : 32'b0; 
			default: out = 0;
		endcase
	end
	assign zero = (0 == out)? 1 : out;
endmodule