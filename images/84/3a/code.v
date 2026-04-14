module top_module (
    input [13:0] in,
    output [12:0] out_and,
    output [12:0] out_nor,
    output [13:0] out_xor_wrap);

assign out_and = in[12:0] & in[13:1];
assign out_nor = ~(in[12:0] | in[11:0]);
assign out_xor_wrap = in ^ {in[12:0], in[13]};

endmodule