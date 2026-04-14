module top_module (
    input [19:0] in,
    output [19:0] out_xor_wrap,
    output [18:0] out_nor,
    output [18:0] out_and);

assign out_xor_wrap = in ^ {in[18:0], in[19]};
assign out_nor = ~(in[18:0] | in[19:1]);
assign out_and = in[18:0] & in[17:0];

endmodule