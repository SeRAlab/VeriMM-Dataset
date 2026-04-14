module top_module(
    input [3:0] bin,
    output parity);assign parity = ~(bin[3] ^ bin[2] ^ bin[1] ^ bin[0]);

endmodule