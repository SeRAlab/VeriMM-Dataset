module top_module(
    input [7:0] binary,
    output [7:0] excess128
);assign excess128 = binary + 128;

endmodule