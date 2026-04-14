module top_module(
    A,
    B,
    C,
    Y0,
    Y1,
    Y2,
    Y3,
    Y4,
    Y5,
    Y6,
    Y7
);input A;
input B;
input C;
output Y0;
output Y1;
output Y2;
output Y3;
output Y4;
output Y5;
output Y6;
output Y7;

wire notA;
wire notB;
wire notC;

assign notA = ~A;
assign notB = ~B;
assign notC = ~C;

assign Y0 = notA & notB & notC; // Y0 = A'B'C'
assign Y1 = notA & notB & C;    // Y1 = A'B'C
assign Y2 = notA & B & notC;     // Y2 = A'BC'
assign Y3 = notA & B & C;        // Y3 = A'BC
assign Y4 = A & notB & notC;     // Y4 = AB'C'
assign Y5 = A & notB & C;        // Y5 = AB'C
assign Y6 = A & B & notC;         // Y6 = ABC'
assign Y7 = A & B & C;           // Y7 = ABC

endmodule