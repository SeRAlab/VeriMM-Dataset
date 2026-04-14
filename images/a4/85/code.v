module ring_counter (
	input clk,
	input resetn,
	output reg [2:0] count);

always @(negedge clk)
	if (!resetn)
		count <= 3'b001;
	else
		count <= {count[1:0], count[2]};

endmodule