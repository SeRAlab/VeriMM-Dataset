module top_module(
    input x_in,
    input y_in,
    input c_in,
    output s_out,
    output c_out
);assign s_out = x_in ^ y_in ^ c_in;            // Sum
    assign c_out = (x_in & y_in) | (c_in & (x_in ^ y_in));  // Carry out
endmodule