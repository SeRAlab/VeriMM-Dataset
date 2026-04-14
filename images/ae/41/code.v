module top_module(
	input[3:0] busin,
	input clk, clr, wa,
	output[3:0] addrout);reg[3:0] store;

	assign addrout= store;

	always@ (posedge clk)
	begin
		if(clr)
			store= 4'h0;
		else if(wa)
			store= busin;
	end
	endmodule