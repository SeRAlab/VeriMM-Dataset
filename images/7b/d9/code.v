module top_module(
    input signed [31:0] input_value,
    output signed [15:0] output_value,
    output signed sign_flag
);assign output_value = input_value >> 16;
assign sign_flag = (input_value < 0) ? 1'b1 : 1'b0;

endmodule