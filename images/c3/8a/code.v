module MUX4to1_using_2to1 (D0, D1, D2, D3, S0, S1, Y);
input D0, D1, D2, D3, S0, S1;
output Y;

wire w1, w2, w3;

// first stage of multiplexing
mux_2to1 m1 (.A(D0), .B(D1), .S(S0), .Y(w1));
mux_2to1 m2 (.A(D2), .B(D3), .S(S0), .Y(w2));

// second stage of multiplexing
mux_2to1 m3 (.A(w1), .B(w2), .S(S1), .Y(w3));

assign Y = w3;

endmodule

module mux_2to1 (A, B, S, Y);
input A, B, S;
output Y;

assign Y = (S == 1'b0) ? A : B;

endmodule