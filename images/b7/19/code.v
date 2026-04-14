module johnson_counter(
	input clk,
	output reg [7:0] q);initial
		q = 8'b00000001;
		
	always @(posedge clk)
		q <= {q[6:0], ~q[7]};
	
endmodule