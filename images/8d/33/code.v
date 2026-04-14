module johnson_counter(
	input clk,
	input rst,
	output reg [7:0] q);
always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 8'b0;
		else
			q <= {q[6:0], ~q[7]};
	end
endmodule