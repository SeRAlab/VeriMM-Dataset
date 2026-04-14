module top_module (
    input [11:0] in,
    output [10:0] out_and,
    output [10:0] out_xor,
    output [11:0] out_diff_wrap);

assign out_and = in[10:0] & in[11:1];
assign out_xor = in[10:0] ^ in[9:0];
assign out_diff_wrap = in != {in[10:0], in[11]};

endmodule