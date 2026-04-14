module top_module(
    input A,
    input B,
    input S,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire Y_temp;
    
    assign Y_temp = (S == 1'b1) ? A : B;
    assign Y = Y_temp;
    
endmodule