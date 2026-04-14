module top_module(A, B, C, D, S0, S1, E, Y);input A, B, C, D, S0, S1, E;
output Y;

wire Y1, Y2, Y3, Y4;

// 4-to-1 multiplexer
assign Y1 = (S1 & ~S0 & ~E) ? A : 1'bx;
assign Y2 = (~S1 & ~S0 & ~E) ? B : 1'bx;
assign Y3 = (S1 & S0 & ~E) ? C : 1'bx;
assign Y4 = (~S1 & S0 & ~E) ? D : 1'bx;

// OR gate
assign Y = (E) ? (A | B | C | D) : ((Y1 & Y2 & Y3 & Y4) ? 1'bx : (Y1 | Y2 | Y3 | Y4));

endmodule