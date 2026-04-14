module top_module(
    COUT,
    SUM ,
    A   ,
    B   ,
    CIN 
);output COUT;
    output SUM ;
    input  A   ;
    input  B   ;
    input  CIN ;
    
    wire w1, w2, w3;
    
    // XOR gates for SUM output
    assign SUM = A ^ B ^ CIN;
    
    // AND gates for COUT output
    assign w1 = A & B;
    assign w2 = A & CIN;
    assign w3 = B & CIN;
    assign COUT = w1 | w2 | w3;
    
endmodule