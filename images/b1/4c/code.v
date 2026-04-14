module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y,
    input VDD,
    input VSS
);assign Y = (S1 & S0 & D) | (S1 & ~S0 & C) | (~S1 & S0 & B) | (~S1 & ~S0 & A);
    
endmodule