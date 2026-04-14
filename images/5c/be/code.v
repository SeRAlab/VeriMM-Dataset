module top_module(
    output X,
    input A0,
    input A1,
    input A2,
    input A3,
    input S0,
    input S1
);assign X = (S1 & S0 & A3) | (~S1 & S0 & A2) | (S1 & ~S0 & A1) | (~S1 & ~S0 & A0);

endmodule