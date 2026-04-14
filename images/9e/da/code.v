module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] SUM,
    output reg COUT
);reg [3:0] stage1_SUM;
reg stage1_COUT;
reg [3:0] stage2_SUM;
reg stage2_COUT;

// Stage 1
always @(*) begin
    stage1_SUM = A + B + CIN;
    stage1_COUT = (stage1_SUM > 15) ? 1 : 0;
end

// Stage 2
always @(*) begin
    stage2_SUM = stage1_SUM[2:0] + A[2:0] + B[2:0] + stage1_COUT;
    stage2_COUT = (stage2_SUM > 7) ? 1 : 0;
end

// Stage 3
always @(*) begin
    SUM = {stage2_SUM[1:0], stage1_SUM[3:2]} + A[3:2] + B[3:2] + stage2_COUT;
    COUT = (SUM > 15) ? 1 : 0;
end

endmodule