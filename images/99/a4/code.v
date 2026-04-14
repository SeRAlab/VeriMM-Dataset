module top_module (
	input [3:0] data,
	input clk,
	input rst,
	output reg [3:0] q);always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 4'b0000;
		else
			q <= {q[2:0], data[3]};
	end
	
endmodule