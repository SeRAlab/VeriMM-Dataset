module top_module(D0, D1, D2, D3, S0, S1, Y);input D0, D1, D2, D3, S0, S1;
output Y;

wire w1, w2, w3;

// Select input 00: Y = D0
assign w1 = ~S0 & ~S1;
assign Y = w1 & D0;

// Select input 01: Y = D1
assign w2 = ~S0 & S1;
assign Y = Y | (w2 & D1);

// Select input 10: Y = D2
assign w3 = S0 & ~S1;
assign Y = Y | (w3 & D2);

// Select input 11: Y = D3
assign Y = Y | (S0 & S1 & D3);

endmodule