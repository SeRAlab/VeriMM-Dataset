module top_module(
    input A1, A2, B1, C1, D1, VPWR, VGND, VPB, VNB,
    output Y
);wire [8:0] input_signals;
    assign input_signals = {A1, A2, B1, C1, D1, VPWR, VGND, VPB, VNB};

    // check if all input signals are at logic level 1
    assign Y = (input_signals == 9'h1ff) ? 1'b1 :
               (input_signals != 9'hxxx) ? 1'b0 :
               1'bx;

endmodule