module top_module(
    output [15:0] decoderout,
    input [3:0] waddr
);assign decoderout = 16'b0000_0000_0000_0001 << waddr;

endmodule