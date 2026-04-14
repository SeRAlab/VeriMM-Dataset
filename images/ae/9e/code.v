module top_module(
    input A,
    input B,
    input C,
    input D,
    output F1,
    output F2
);wire and1, and2, or1;

assign and1 = A & B;
assign and2 = C & D;
assign or1 = A | B;

assign F1 = and1 & and2;
assign F2 = or1 | and2;

endmodule