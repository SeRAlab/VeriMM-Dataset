module johnson_counter (
	input clk,
	input resetn,
	output reg [6:0] count);

always @(posedge clk)
	if (!resetn)
		count <= 7'b0000000;
	else
		count <= {~count[6], count[6:1]};

endmodule