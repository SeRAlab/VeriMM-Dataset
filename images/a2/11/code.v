module top_module(
    A,
    B,
    C,
    D,
    X
);// Module ports
    input  A;
    input  B;
    input  C;
    input  D;
    output X;

    // Local signals
    wire   xnor0_out;
    wire   xnor1_out;
    wire   buf0_out;

    //   Name     Output         Other arguments
    xnor xnor0  (xnor0_out , A, B, C);
    xnor xnor1  (xnor1_out , xnor0_out, D, 1'b1);
    buf  buf0   (buf0_out  , xnor1_out);

    assign X = buf0_out;

endmodule