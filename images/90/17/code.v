module top_module(
    input input_1,
    input input_2,
    input input_3,
    input input_4,
    output output_signal
);assign output_signal = (input_1 & input_2) | (input_2 & input_3) | (input_3 & input_4);

endmodule