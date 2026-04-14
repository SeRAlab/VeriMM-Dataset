module johnson_counter (
	input clk,
	output reg [3:0] count);always @(posedge clk)
		count <= {~count[0], count[3:1]};

endmodule