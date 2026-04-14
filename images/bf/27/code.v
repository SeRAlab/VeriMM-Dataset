module top_module(
    // input and output ports
    output Y,
    input A,
    input B,
    input C,
    input D
);// supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // local signals
    wire nor1_out_Y;
    wire nor2_out_Y;
    wire nor3_out_Y;
    wire nor4_out_Y;

    // NOR gates
    nor nor1 (nor1_out_Y, A, B);
    nor nor2 (nor2_out_Y, C, D);
    nor nor3 (nor3_out_Y, nor1_out_Y, nor2_out_Y);
    nor nor4 (Y, nor3_out_Y);

endmodule