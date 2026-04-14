module top_module(
    output X,
    input  A,
    input  B,
    input  C,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);// The following code snippet performs the XOR operation between three inputs
    // It combines the inputs A, B, and C using the XOR operation
    
    assign X = A ^ B ^ C;  // Directly XOR all three inputs
    
endmodule