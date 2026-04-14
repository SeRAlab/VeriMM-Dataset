module top_module(
        input wire clk,
        input wire pix,
        input [1:0] cd,
        input inframe,
        output reg [9:0] tmds
);wire [9:0] word = 10'b1100000111;
    wire [9:0] data = pix ? ~word : word;
    wire [9:0] base = cd[1] ? 10'b0101010100 : 10'b1101010100;
    wire [9:0] ctrl = cd[0] ? ~base : base;

    always @(posedge clk)
        tmds <= inframe ? data : ctrl;

endmodule