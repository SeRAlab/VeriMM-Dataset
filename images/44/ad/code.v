module top_module(
	input [29:0] shiftMe,
	output reg [31:0] shifted);always @(shiftMe) begin
		shifted = {shiftMe[29:0], 2'b00}; 
	end

endmodule