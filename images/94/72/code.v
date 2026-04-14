module top_module(
    input [3:0] bin,
    output [3:0] bcd);assign bcd = (bin > 4'd9) ? 4'd9 : bin;

endmodule