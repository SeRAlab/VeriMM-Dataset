module top_module(
    Y  ,
    A  ,
    B  ,
    C  ,
    D  
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D  ;

    // Local signals
    wire not_A_signal;
    wire not_B_signal;
    wire not_C_signal;
    wire not_D_signal;
    wire nor0_out;
    wire nor1_out;

    // Invert inputs
    not not_A (not_A_signal, A);
    not not_B (not_B_signal, B);
    not not_C (not_C_signal, C);
    not not_D (not_D_signal, D);

    // NOR gates
    nor nor0 (nor0_out, not_A_signal, not_B_signal);
    nor nor1 (nor1_out, nor0_out, not_C_signal);
    nor nor2 (Y, nor1_out, not_D_signal);

endmodule