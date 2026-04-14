module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output reg Y
);wire not_s0 = ~S0;
    wire not_s1 = ~S1;

    assign Y = (A & not_s1 & not_s0) | (B & not_s1 & S0) | (C & S1 & not_s0) | (D & S1 & S0);

endmodule