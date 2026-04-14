module top_module(clk, ina, inb, product);parameter SIZE_A = 16;
	parameter SIZE_B = 8;
	parameter PIPE_LEVEL = 1; 
	
	input clk;
	input signed[SIZE_A-1:0] ina;
	input signed[SIZE_B-1:0] inb;
	output signed[SIZE_A+SIZE_B-1:0] product;
	
	reg signed[SIZE_A-1:0] a;
	reg signed[SIZE_B-1:0] b;
	
	reg signed[SIZE_A+SIZE_B-1:0] partial[PIPE_LEVEL-1:0];
	
	integer i;
	always @(posedge clk)
	begin
	  a <= ina;
	  b <= inb;
	end
	
	always @(posedge clk)
	  partial[0] <= a * b;
	
	always @(posedge clk)
	for (i = 1;i < PIPE_LEVEL; i=i+1)
	  partial[i] <= partial[i-1];
	
	assign product = partial[PIPE_LEVEL-1];endmodule