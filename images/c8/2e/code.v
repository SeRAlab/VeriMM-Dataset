module reduce_and(
    input [3:0] in_vec,
    output out_bit
);

assign out_bit = &in_vec;

endmodule