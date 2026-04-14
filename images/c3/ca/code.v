module signal_processing(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);

    wire B1_OR_B2;
    
    assign B1_OR_B2 = B1 | B2;
    
    assign Y = (A1_N & A2_N) ? B1_OR_B2 : (A1_N & ~A2_N) ? B1 : (~A1_N & A2_N) ? B2 : 0;
    
endmodule