module top_module(
    input clk,
    input [15:0] in,
    output reg [3:0] i_high1,
    output reg [3:0] i_low1,
    output reg [3:0] i_high0,
    output reg [3:0] i_low0,
    input [3:0] o_high1,
    input [3:0] o_low1,
    input [3:0] o_high0,
    input [3:0] o_low0,
    output reg [15:0] out
);always @(posedge clk) begin
    i_high1 <= in[15:12];
    i_low1 <= in[11:8];
    i_high0 <= in[7:4];
    i_low0 <= in[3:0];
    out[15:12] <= o_high1;
    out[11:8] <= o_low1;
    out[7:4] <= o_high0;
    out[3:0] <= o_low0;
end

endmodule