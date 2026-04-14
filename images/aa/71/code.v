module top_module(
    input [15:0] operand1,
    input [15:0] operand2,
    input carry_in,
    input clk,                // Added clock signal as input
    output [15:0] sum,
    output carry_out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;
reg [15:0] stage4_out;
reg [15:0] stage5_out;

assign sum = stage5_out;
assign carry_out = stage5_out[15];

always @(posedge clk) begin
    stage1_out <= operand1 + operand2 + carry_in;
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

always @(posedge clk) begin
    stage3_out <= stage2_out;
end

always @(posedge clk) begin
    stage4_out <= stage3_out;
end

always @(posedge clk) begin
    stage5_out <= stage4_out;
end

endmodule