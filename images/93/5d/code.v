module top_module(
    input A,
    input B,
    input S,
    output Y
);wire notS = ~S;
    wire and1 = A & notS;
    wire and2 = B & S;
    assign Y = and1 | and2;

endmodule