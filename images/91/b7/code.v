module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire AB, CD, ABCD;
    
    assign AB = ~(A ^ B);
    assign CD = ~(C ^ D);
    assign ABCD = ~(AB ^ CD);
    assign Y = ABCD;
    
endmodule