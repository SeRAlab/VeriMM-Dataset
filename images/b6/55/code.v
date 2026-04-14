module top_module(
    input En,
    input A0,
    input A1,
    output [3:0] Y
    );assign Y = (~En) ? 4'b1111 : (
				  ((~A1) & (~A0)) ? 4'b1110 : (
				  ((~A1) & A0   ) ? 4'b1101 : (
				  (A1    & (~A0)) ? 4'b1011 : 4'b0111
				  )));

endmodule