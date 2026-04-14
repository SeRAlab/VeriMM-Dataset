module audio_mixer (
    input [7:0] signal1,
    input [7:0] signal2,
    output [7:0] mixed_signal
);
    assign mixed_signal = (signal1 + signal2) >> 1; // Average of the two signals
endmodule