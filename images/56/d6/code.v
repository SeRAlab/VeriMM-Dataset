module top_module(
    output Y, 
    input A, B, C, D,
    input VPWR, 
    input VGND, 
    input VPB, 
    input VNB
);// Local signals
    wire nor1_out, nor2_out;

    // NOR gates
    nor nor1(nor1_out, A, B);
    nor nor2(nor2_out, C, D);
    nor nor3(Y, nor1_out, nor2_out);

endmodule