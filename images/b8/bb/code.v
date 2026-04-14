module reg_8bit (
	input clk,
	input set,
	input reset,
	input [7:0] data_in,
	output reg [7:0] q);always @(posedge clk) begin
	if (reset)
		q <= 8'b00000000;
	else if (set)
		q <= 8'b11111111;
	else
		q <= data_in;
end

endmodule