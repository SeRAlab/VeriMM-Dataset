module top_module(
    input [7:0] input_signals,
    output output_signal
);wire [7:0] input_signals_inverted;
    assign input_signals_inverted = ~input_signals;

    wire [3:0] num_ones;
    assign num_ones = {
        input_signals_inverted[0] & input_signals[1],
        input_signals_inverted[1] & input_signals[2],
        input_signals_inverted[2] & input_signals[3],
        input_signals_inverted[3] & input_signals[4],
        input_signals_inverted[4] & input_signals[5],
        input_signals_inverted[5] & input_signals[6],
        input_signals_inverted[6] & input_signals[7],
        input_signals_inverted[7]
    };

    wire at_least_four_ones;
    assign at_least_four_ones = (num_ones[0] + num_ones[1] + num_ones[2] + num_ones[3] + num_ones[4] + num_ones[5] + num_ones[6] + num_ones[7]) >= 4;

    assign output_signal = at_least_four_ones;

endmodule