module top_module(a, b,f_and,f_or,f_not,f_nand,f_nor,f_xor,f_xnor);input a,b;
	output f_and, f_or,f_not,f_nand,f_nor,f_xor,f_xnor;
	assign f_and = a&b;
	assign f_or = a|b;
	assign f_not = ~a;
	assign f_nand = ~(a&b);
	assign f_nor = ~(a|b);
	assign f_xor = a^b;
	assign f_xnor = ~(a^b);
endmodule