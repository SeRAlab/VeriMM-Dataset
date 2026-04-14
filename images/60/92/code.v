module top_module(input x, y, cIn, output s,carryO);assign s=x^y^cIn;
		assign carryO=(~x&y)|(~x&cIn)|(y&cIn);endmodule