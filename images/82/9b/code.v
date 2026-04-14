module top_module (
	input clk,
	input p,
	input q,
	output reg r,
	output reg state);reg e;
	always @(posedge clk)
		e <= p&q | p&e | q&e;
	
	assign r = p^q^e;
	assign state = e;
			
endmodule