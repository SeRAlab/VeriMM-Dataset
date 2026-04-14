module johnson_counter (
	input clk,
	input reset,
	output reg [2:0] count);

always @(posedge clk or negedge reset)
	if (!reset)
		count <= 3'b111;
	else
		count <= {count[1:0], ~count[2]};

endmodule