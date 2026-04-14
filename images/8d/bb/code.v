module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] C
);reg [3:0] stage1_out;
reg [3:0] stage2_out;
reg [3:0] stage3_out;
reg [3:0] stage4_out;

always @(*) begin
    stage1_out = (B[0]) ? {A[2:0], 1'b0} : A;
end

always @(*) begin
    stage2_out = (B[1]) ? {stage1_out[1:0], A[3:2]} : stage1_out;
end

always @(*) begin
    stage3_out = (B[2]) ? {stage2_out[2:0], A[3]} : stage2_out;
end

always @(*) begin
    stage4_out = (B[3]) ? {A[0], stage3_out[2:0]} : stage3_out;
end

assign C = stage4_out;

endmodule