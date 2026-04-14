module top_module(
    input [3:0] input_number,
    output [3:0] output_number
);assign output_number = ~input_number + 1;
endmodule