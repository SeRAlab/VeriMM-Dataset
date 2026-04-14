module top_module (
    input [14:0] in,
    output [14:0] out_xor_wrap,
    output [13:0] out_nand,
    output [13:0] out_or);

assign out_xor_wrap = in ^ {in[13:0], in[14]};
assign out_nand = ~(in[13:0] & in[12:0]);
assign out_or = in[13:0] | in[12:0];

endmodule