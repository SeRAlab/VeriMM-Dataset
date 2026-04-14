module top_module(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1,
    input VPWR,  // Added direction declaration
    input VGND   // Added direction declaration
);assign Y = ((A1 & A2 & A3) | (A1 & ~B1) | (~A1 & B1) | (~A1 & ~A2 & ~A3 & B1)) ? 1'b1 : 1'b0;

endmodule