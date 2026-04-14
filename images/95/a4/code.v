module top_module(
    input A,
    input B,
    input S0,
    input S1,
    output Y
);assign Y = (~S0 & ~S1 & A) | (~S0 & S1 & B) | (S0 & ~S1 & A) | (S0 & S1 & B);

endmodule