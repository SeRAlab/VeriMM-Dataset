module top_module(
    input [3:0] in_vec,
    output out_bit
);assign out_bit = &in_vec;

endmodule