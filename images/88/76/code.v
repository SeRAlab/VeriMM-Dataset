module top_module(
    input [7:0] rx,
    input [7:0] ry,
    output [7:0] and_out,
    output [7:0] adder_out,
    output [7:0] is_zero_out
);assign and_out = rx & ry;
assign is_zero_out = rx == 0 ? 8'h01 : 0;
assign adder_out = rx + ry;
endmodule