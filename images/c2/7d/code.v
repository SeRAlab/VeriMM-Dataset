module six_input_module (
    input A1, A2, B1, B2, C1, VPB, VPWR, VGND, VNB, 
    output Y
);

    assign Y = ((A1 & A2 & ~B1 & ~B2) | (~A1 & ~A2 & B1 & B2) | C1) ? 1'b1 : 1'b0;

endmodule