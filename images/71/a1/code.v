module top_module(
    Y  ,
    A_N,
    B_N,
    C  ,
    D
);// Module ports
    output Y  ;
    input  A_N;
    input  B_N;
    input  C  ;
    input  D  ;

    // Local signals
    wire nand0_out;
    wire nand1_out;
    wire nand2_out;
    wire or0_out_Y;

    //   Name   Output     Other arguments
    nand nand0 (nand0_out, A_N, B_N);
    nand nand1 (nand1_out, C, D);
    nand nand2 (nand2_out, nand0_out, nand1_out);
    or   or0   (or0_out_Y, nand2_out, nand2_out);
    buf  buf0  (Y        , or0_out_Y          );

endmodule