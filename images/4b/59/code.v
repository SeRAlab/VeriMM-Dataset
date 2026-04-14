module top_module(
	input t,
	input u,
	output reg v);assign v = ~(t ^ u);
	
endmodule