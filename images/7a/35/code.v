module top_module(q, d, reset, clk);output q;
	input d, reset, clk;
	reg q; 
	always @(posedge clk or posedge reset)
	if (reset)
	q = 0; 
	else
	q = d;
endmodule