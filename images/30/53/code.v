module phase_shifter (
    input [2:0] phase_shift,
    input [4:0] signal_in,
    output [4:0] signal_out
);
    assign signal_out = {signal_in[4:0]} << phase_shift;
endmodule