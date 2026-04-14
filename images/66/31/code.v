module top_module(
    input [2:0] in,
    input enable,
    output [7:0] out
);assign out = (enable) ? {~in[2], ~in[1], ~in[0], in[2], in[1], in[0], 1'b0, 1'b0} : 8'b0;

endmodule