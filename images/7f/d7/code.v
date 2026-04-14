module top_module(
    input wire [2:0] in_vec,
    output wire [2:0] out_vec
);assign out_vec[0] = in_vec[0] & 1'b1;
assign out_vec[1] = in_vec[1] & 1'b1;
assign out_vec[2] = in_vec[2] & 1'b1;

endmodule