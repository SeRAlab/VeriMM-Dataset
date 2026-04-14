module top_module(Mode, IRL, y, X);input Mode, IRL;
	input [1:0]y;
	output [1:0]X;
	
	assign X[1] = (Mode & y[0]) | (Mode & y[1]);
	assign X[0] = (~Mode & y[0]) | (~Mode & y[1]) | (IRL & ~Mode) | (IRL & ~y[1] & ~y[0]);
	
endmodule