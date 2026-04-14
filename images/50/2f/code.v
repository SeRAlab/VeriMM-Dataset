module top_module(
    input [15:0] input_signal,
    output [23:0] output_signal
);wire [7:0] first_8_bits = input_signal[7:0];
    wire [7:0] last_8_bits = input_signal[15:8];
    wire [23:0] sum_prod_result = {first_8_bits + last_8_bits, first_8_bits * last_8_bits};

    assign output_signal = sum_prod_result;

endmodule