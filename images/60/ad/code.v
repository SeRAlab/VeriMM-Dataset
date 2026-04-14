module top_module (
    input [7:0] in,
    output [6:0] out_greater,
    output [6:0] out_equal,
    output [7:0] out_wrap);

assign out_greater = in[7:1] > in[6:0];
assign out_equal = in[6:0] == in[7:1];
assign out_wrap = in == {in[6:0], in[7]};

endmodule