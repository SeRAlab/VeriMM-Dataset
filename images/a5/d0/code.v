module top_module(
    input A,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);// Fixing the unknown module issue by using a generic buffer implementation
    assign X = A;

endmodule