module top_module(
    input [11:0] a,
    input [9:0] b,
    input clk,
    output reg [23:0] p
);// Basic multiplier logic (simple example)
    always @(posedge clk) begin
        p <= a * b;
    end
endmodule