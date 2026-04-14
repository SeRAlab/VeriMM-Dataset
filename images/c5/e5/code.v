module mux_4to1 (
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);

    assign Y = (~S1 & ~S0 & A) | (~S1 & S0 & B) | (S1 & ~S0 & C) | (S1 & S0 & D);

endmodule