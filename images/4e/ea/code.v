module top_module(A, B, S, CO);input A;
input B;
output S;
output CO;

wire w1, w2, w3;
xor x1(w1, A, B);
and a1(w2, A, B);
xor x2(S, w1, CO);
and a2(w3, w1, CO);
or o1(CO, w2, w3);

endmodule