module top_module(Din,prepro,Dout);input [3:0] Din;
	input [3:0] prepro;
	output [3:0] Dout;
	
	assign Dout = Din | prepro;
	
endmodule