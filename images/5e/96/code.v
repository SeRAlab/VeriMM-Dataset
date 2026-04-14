module top_module(
		input [31:0] b,
		output reg[4:0] splited
	);always @(*) begin
		splited = b[4:0];
	end

endmodule