module top_module(
    input input_1,
    input input_2,
    input input_3,
    input input_4,
    input input_5,
    input input_6,
    input input_7,
    input input_8,
    input input_9,
    input input_10,
    output output_1
);assign output_1 = (input_1) ? 1 :
                      (input_2 & input_3) ? 1 :
                      (input_4 | input_5) ? 1 :
                      (input_6 & input_7 & input_8) ? 1 :
                      (input_9 & input_10) ? 1 :
                      0;

endmodule