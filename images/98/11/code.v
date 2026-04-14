module top_module(
    input clk,          // Added clk input
    input [3:0] a,
    input [3:0] b,
    output reg [3:0] sum
);reg [3:0] stage1_sum;
reg [3:0] stage2_sum;

always @(*) begin
    stage1_sum = a + b;
end

always @(*) begin
    stage2_sum = stage1_sum; // Corrected to use stage1_sum correctly
end

always @(posedge clk) begin
    sum <= stage2_sum[3:0];
end

endmodule