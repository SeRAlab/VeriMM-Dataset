module top_module(A, B, Out);input [15:0] A, B;
output [15:0] Out;

wire compare;

assign compare = |(A ^ B);
assign Out = (~compare) ? 1 : 0;

endmodule