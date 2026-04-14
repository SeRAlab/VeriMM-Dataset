module top_module (
	input [2:0] in,
	output reg [7:0] out);always @(*) begin
		out = 8'b00000000;
		out[in] = 1'b1;
	end
	
endmodule