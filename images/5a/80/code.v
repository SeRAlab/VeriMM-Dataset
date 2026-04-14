module top_module(
    input [15:0] binary_input,
    output [15:0] gray_code_output
);assign gray_code_output = binary_input ^ (binary_input >> 1);

endmodule