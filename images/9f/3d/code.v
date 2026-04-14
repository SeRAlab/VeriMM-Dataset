module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk, // Added clk input
    output reg [3:0] out
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @ (posedge clk) begin
    stage1_out <= a | b;
end

always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

assign out = stage2_out;

endmodule