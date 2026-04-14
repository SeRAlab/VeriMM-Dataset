module top_module(
    input [7:0] x,
    output [7:0] d_out
    );assign d_out = (x<<1) ^ (((x>>7) & 8'b1) * 8'h1b);
endmodule