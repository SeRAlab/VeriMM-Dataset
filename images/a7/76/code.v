module top_module(
    input wire [2:0] input_vector,
    output wire [2:0] output_vector,
    output wire output_2,
    output wire output_1,
    output wire output_0
);assign output_2 = input_vector[2];
assign output_1 = input_vector[1];
assign output_0 = input_vector[0];
assign output_vector = input_vector;

endmodule