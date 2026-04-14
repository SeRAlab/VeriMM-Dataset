module top_module(
    input signed [31:0] in1,
    input signed [31:0] in2,
    output reg signed [31:0] out
);reg signed [31:0] stage1_out;
reg signed [31:0] stage2_out;

always @(in1, in2) begin
    stage1_out <= in1 & in2;
end

always @(stage1_out) begin
    stage2_out <= stage1_out;
end

always @(stage2_out) begin
    out <= stage2_out;
end

endmodule