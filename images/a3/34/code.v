module top_module(
    input clk,
    input enable,
    input [4:0] Data,
    output reg [4:0] Q
    );always @(posedge clk)
        Q <= Data;endmodule