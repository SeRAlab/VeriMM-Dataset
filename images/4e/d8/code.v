module top_module(
    input wire [2:0] in_vec,
    output wire [2:0] out_vec,
    output wire out_2,
    output wire out_1,
    output wire out_0
);assign out_vec = in_vec;
assign out_2 = in_vec[2];
assign out_1 = in_vec[1];
assign out_0 = in_vec[0];

endmodule