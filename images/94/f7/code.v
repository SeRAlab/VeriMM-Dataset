module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk, // Added clock input
    output signed [3:0] sum,
    output carry_out
);reg signed [3:0] stage1_sum;
reg stage1_carry_out;
reg signed [3:0] stage2_sum;
reg stage2_carry_out;

assign sum = stage2_sum;
assign carry_out = stage2_carry_out;

always @(*) begin
    stage1_sum = A + B;
    stage1_carry_out = (A[3] & B[3]) | (A[3] & ~stage1_sum[3]) | (B[3] & ~stage1_sum[3]);
end

always @(posedge clk) begin
    stage2_sum <= stage1_sum; // Use non-blocking assignment
    stage2_carry_out <= stage1_carry_out; // Use non-blocking assignment
end

endmodule