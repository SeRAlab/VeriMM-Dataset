module top_module(
    Y  ,
    A  ,
    B  ,
    C_N,
    D_N
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;

    // Local signals
    wire not0_out  ;
    wire not1_out  ;
    wire and0_out  ;
    wire and1_out  ;
    wire and2_out  ;
    wire or0_out   ;
    wire nor0_out  ;
    wire nor1_out  ;
    wire xor0_out  ;
    wire xor1_out  ;
    wire xor2_out  ;
    wire xor3_out  ;
    wire xor4_out  ;
    wire xor5_out  ;
    wire xor6_out  ;
    wire xor7_out  ;
    wire xor8_out  ;
    wire xor9_out  ;
    wire xor10_out ;
    wire xor11_out ;
    wire xor12_out ;
    wire xor13_out ;
    wire xor14_out ;
    wire xor15_out ;

    //  Name  Output      Other arguments
    not not0 (not0_out, A);
    not not1 (not1_out, B);
    and and0 (and0_out, not0_out, not1_out, C_N, D_N);
    and and1 (and1_out, A, not1_out, C_N, D_N);
    and and2 (and2_out, not0_out, B, C_N, D_N);
    or or0 (or0_out, and0_out, and1_out, and2_out);
    nor nor0 (nor0_out, or0_out, or0_out);
    xor xor0 (xor0_out, A, B);
    xor xor1 (xor1_out, xor0_out, C_N);
    xor xor2 (xor2_out, xor0_out, D_N);
    xor xor3 (xor3_out, xor1_out, xor2_out);
    xor xor4 (xor4_out, A, C_N);
    xor xor5 (xor5_out, xor4_out, D_N);
    xor xor6 (xor6_out, B, C_N);
    xor xor7 (xor7_out, xor6_out, D_N);
    xor xor8 (xor8_out, A, D_N);
    xor xor9 (xor9_out, xor8_out, C_N);
    xor xor10 (xor10_out, B, D_N);
    xor xor11 (xor11_out, xor10_out, C_N);
    xor xor12 (xor12_out, xor4_out, xor6_out);
    xor xor13 (xor13_out, xor8_out, xor10_out);
    xor xor14 (xor14_out, xor1_out, xor6_out);
    xor xor15 (xor15_out, xor2_out, xor4_out);
    nor nor1 (nor1_out, xor3_out, xor5_out, xor7_out, xor9_out, xor11_out, xor12_out, xor13_out, xor14_out, xor15_out);
    buf buf0 (Y, nor1_out);

endmodule