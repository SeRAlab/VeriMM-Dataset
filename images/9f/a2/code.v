module top_module(a,b,and_op,or_op,not_op,nand_op,nor_op,xor_op,xnor_op);input a,b;
	output and_op,or_op,not_op,nand_op,nor_op,xor_op,xnor_op;
	assign and_op=a&b;
	assign or_op=a|b;
	assign not_op=~a;
	assign nand_op=~and_op;
	assign nor_op=~or_op;
	assign xor_op=(~a&b)|(a&~b);
	assign xnor_op=~xor_op;endmodule