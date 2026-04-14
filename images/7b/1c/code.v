module top_module(
    output Y,
    input  A,
    input  B,
    input  C,
    input  D,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);wire n1, n2;

    // Using behavioral description for NOR gates
    assign n1 = ~(A | B); // NOR operation for inputs A and B
    assign n2 = ~(C | D); // NOR operation for inputs C and D
    assign Y  = ~(n1 | n2); // Final NOR operation on the results of previous NORs

endmodule