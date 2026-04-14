module top_module(
    // inputs
    input A_N,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    
    // outputs
    output X
);// Implement AND gate
    assign X = ~(A_N | ~B);

endmodule