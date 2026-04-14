module top_module(
    input wire [2:0] in_num,
    output wire [2:0] out_num,
    output wire o2,
    output wire o1,
    output wire o0
);assign o0 = in_num[0];
assign o1 = in_num[1];
assign o2 = in_num[2];
assign out_num = in_num;

endmodule