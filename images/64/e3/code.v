module register_with_set(
	input clk,
	input rst,
	input set,
	input [7:0] data_in,
	output reg [7:0] q);
always @(posedge clk) begin
		if (rst)
			q <= 8'b0;
		else if (set)
			q <= 8'b11111111;
		else
			q <= data_in;
	end
endmodule