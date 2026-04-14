module echo_cancellation (
    input [7:0] input_signal,
    input [7:0] echo_signal,
    output [7:0] output_signal
);

assign output_signal = input_signal - echo_signal;

endmodule