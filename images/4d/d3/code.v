module top_module(
    input [1:0] signal_d,
    input [2:0] signal_e,
    output signal_f
);assign signal_f = (signal_d > signal_e) ? 1 : 0;

endmodule