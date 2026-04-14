module top_module (
    input [8:0] in,
    output [8:0] out_or_wrap,
    output [7:0] out_xor,
    output [7:0] out_nand);

assign out_or_wrap = in | {in[7:0], in[8]};
assign out_xor = in[7:0] ^ in[8:1];
assign out_nand = ~(in[7:0] & in[6:0]);

endmodule