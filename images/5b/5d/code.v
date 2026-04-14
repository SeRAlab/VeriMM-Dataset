module top_module(
	input [2:0] op,
	input [63:0] lhs,
	input [63:0] rhs,
	output [63:0] result,

			
	output zero,	
	output sign	
);parameter ALU_NOP	= 3'b000;
	parameter BIT_AND	= 3'b001;
	parameter BIT_OR	= 3'b010;
	parameter BIT_XOR	= 3'b011;

	parameter ADD_64	= 3'b110;
	parameter SUB_64	= 3'b111;

	wire [63:0] result_tmp;

	assign result_tmp =	(op == ADD_64) ? lhs + rhs :
				((op == SUB_64) ? lhs - rhs :
				((op == BIT_AND) ? lhs & rhs : 
				((op == BIT_OR) ? lhs | rhs :
				((op == BIT_XOR) ? lhs ^ rhs : 64'h0))));

	assign zero = (result_tmp == 0) ? 1'b1 : 1'b0;
	assign sign = result_tmp[63];
	assign result = result_tmp;

endmodule