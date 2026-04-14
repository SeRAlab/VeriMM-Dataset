module top_module(
    input [11:0] lhs,
    input [11:0] rhs,
    output [11:0] result,
    output overflow
    );assign overflow = lhs < rhs;
	assign result = lhs - rhs;
endmodule