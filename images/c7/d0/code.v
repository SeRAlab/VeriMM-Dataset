module signal_process(
    input [7:0] input_signal,
    output [7:0] output_signal
);

    assign output_signal = {~input_signal[3:0], input_signal[7:4] << 2};

endmodule