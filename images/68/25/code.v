module top_module(
    COUT,
    SUM,
    A,
    B,
    CIN,
    VPWR,
    VGND,
    VPB,
    VNB
);output COUT;
    output SUM;
    input  A;
    input  B;
    input  CIN;
    input  VPWR;
    input  VGND;
    input  VPB;
    input  VNB;

    wire temp1, temp2, temp3;
    
    assign SUM = A ^ B ^ CIN; // Sum calculation
    assign temp1 = (A & B) | (CIN & (A ^ B)); // Carry out calculation
    assign COUT = temp1;

endmodule