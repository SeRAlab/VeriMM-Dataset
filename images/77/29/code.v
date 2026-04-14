module top_module(
    X,
    A,
    B
);output X;
    input  [2:0] A;
    input  [2:0] B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Implement your 3-bit comparator here
    assign X = ((A[2] >= B[2]) && (A[1] >= B[1]) && (A[0] >= B[0])) ? 1'b1 : 1'b0;

endmodule