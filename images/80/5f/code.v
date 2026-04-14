module top_module(D0, D1, D2, D3, S0, S1, Y);input D0, D1, D2, D3;
input S0, S1;
output Y;

wire sel0, sel1;

// Select bit decoding
not(nS0, S0);
not(nS1, S1);
and(sel0, D0, nS0, nS1);
and(sel1, D1, S0, nS1);
and(sel2, D2, nS0, S1);
and(sel3, D3, S0, S1);

// Multiplexer output
or(Y, sel0, sel1, sel2, sel3);

endmodule