module counter (
	input clk,
	input resetn,
	input load,
	input [2:0] load_val,
	output reg [2:0] count);

always @(posedge clk or negedge resetn)
	if (!resetn)
		count <= 3'b000;
	else if (load)
		count <= load_val;
	else
		count <= count + 1;

endmodule