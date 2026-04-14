module top_module(
    input A,
    input B,
    input C,
    output Y,
    input VPWR,
    input VGND
);assign Y = ~(A & B & C);

endmodule