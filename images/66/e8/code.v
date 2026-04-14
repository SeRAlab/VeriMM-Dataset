module gray_code_counter(
	input clk,
	output reg [2:0] q);initial
		q = 3'b000;
		
	always @(posedge clk)
		q <= {q[2], q[1] ^ q[2], q[0] ^ q[1]};
	
endmodule