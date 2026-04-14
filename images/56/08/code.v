module top_module (
    input [9:0] in,
    output [8:0] out_even,
    output [8:0] out_odd,
    output [9:0] out_flip);

assign out_even = ~in[8:0] & ~in[9:1];
assign out_odd = in[8:0] & in[9:1];
assign out_flip = in ^ {in[0], in[9:1]};

endmodule