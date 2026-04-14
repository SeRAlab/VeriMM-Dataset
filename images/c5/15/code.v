module my_module (
    out_signal,
    in_signal_1,
    in_signal_2,
    in_signal_3,
    in_signal_4,
    in_signal_5
);

    // Module ports
    output out_signal;
    input  in_signal_1;
    input  in_signal_2;
    input  in_signal_3;
    input  in_signal_4;
    input  in_signal_5;

    // Local signals
    wire sig1;
    wire sig2;

    //  Name  Output      Other arguments
    and and0 (sig1, in_signal_1, in_signal_2);
    nor nor0 (sig2, in_signal_3, in_signal_4, in_signal_5, sig1);
    buf buf0 (out_signal, sig2);

endmodule