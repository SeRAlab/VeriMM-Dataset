module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] SUM,
    output reg COUT
);reg [3:0] stage1_SUM, stage2_SUM, stage3_SUM;
reg stage1_COUT, stage2_COUT;

// Stage 1
always @(*) begin
    stage1_SUM[0] = A[0] ^ B[0] ^ CIN;
    stage1_COUT = (A[0] & B[0]) | (A[0] & CIN) | (B[0] & CIN);
end

// Stage 2
always @(*) begin
    stage2_SUM[1] = A[1] ^ B[1] ^ stage1_COUT;
    stage2_COUT = (A[1] & B[1]) | (A[1] & stage1_COUT) | (B[1] & stage1_COUT);
end

// Stage 3
always @(*) begin
    stage3_SUM[2] = A[2] ^ B[2] ^ stage2_COUT;
    COUT = (A[2] & B[2]) | (A[2] & stage2_COUT) | (B[2] & stage2_COUT);
end

// Stage 4
always @(*) begin
    stage3_SUM[3] = A[3] ^ B[3] ^ COUT;
    SUM = stage3_SUM;
end

endmodule