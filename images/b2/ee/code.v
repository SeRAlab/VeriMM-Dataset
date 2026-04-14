module top_module(
    input [15:0] in,
    output flag_negative, flag_zero, flag_positive
    );assign flag_negative = in[15];
    assign flag_zero = ~(|in);
    assign flag_positive = ~(flag_negative | flag_zero);
endmodule