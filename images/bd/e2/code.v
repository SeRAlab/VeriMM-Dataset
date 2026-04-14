module top_module(x,y,extra,out,carry);input x,y,extra;
	output out,carry;
	assign out = x^y^extra;
	assign carry = (x&y|x&extra|y&extra);endmodule