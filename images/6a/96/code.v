module register_32bit(
	input clk,
	input rst,
	input ena,
	input [31:0] data_in,
	output reg [31:0] q);
always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 32'b0;
		else if (ena)
			q <= data_in;
	end
endmodule