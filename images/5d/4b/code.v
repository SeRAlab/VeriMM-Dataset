module top_module(
    input input_1,
    input input_2,
    input input_3,
    input input_4,
    input input_5,
    output output_1
);wire signal_1;
    wire signal_2;
    wire signal_3;

    assign signal_1 = input_1 & input_2;
    assign signal_2 = input_3 | input_4;
    assign signal_3 = signal_1 ^ signal_2;
    assign output_1 = ~signal_3;

endmodule