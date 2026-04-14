module top_module(
    input [0:49] input_vector,
    output [0:49] output_vector
    );assign output_vector = {input_vector[49],input_vector[0:48]};


endmodule