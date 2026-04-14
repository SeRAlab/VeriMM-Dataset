module top_module(A, B, EN, Z);input A, B, EN;
output [0:3] Z;

wire Abar, Bbar;

assign Abar = ~A;
assign Bbar = ~B;

assign Z[0] = ~(Abar & Bbar & EN);
assign Z[1] = ~(Abar & B & EN);
assign Z[2] = ~(A & Bbar & EN);
assign Z[3] = ~(A & B & EN);

endmodule