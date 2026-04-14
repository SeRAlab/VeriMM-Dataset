module top_module(
    input [15:0] A,
    input [3:0] shift,
    output reg [15:0] Y
);reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;

always @(*) begin
    stage1_out = (shift[3]) ? {A[15], A} : A;
end

always @(*) begin
    stage2_out = (shift[2]) ? {stage1_out[14:0], stage1_out[15]} : stage1_out;
end

always @(*) begin
    stage3_out = (shift[1]) ? {stage2_out[13:0], stage2_out[15:14]} : stage2_out;
end

always @(*) begin
    Y = (shift[0]) ? {stage3_out[12:0], stage3_out[15:13]} : stage3_out;
end

endmodule