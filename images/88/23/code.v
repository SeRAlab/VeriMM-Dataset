module top_module(
    input A,
    input B,
    input C,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);// Implement AND gate logic
    assign X = A & B & C;

endmodule