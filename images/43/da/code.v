module top_module(
    input [3:0] A,
    input [1:0] shift_amount,
    input shift_dir,
    output [3:0] Y
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    stage1_out[0] = A[shift_amount[0]];
    stage1_out[1] = A[shift_amount[1]];
    stage1_out[2] = A[shift_amount[0]+2];
    stage1_out[3] = A[shift_amount[1]+2];
end

always @(*) begin
    if (shift_dir) begin
        stage2_out[0] = stage1_out[1];
        stage2_out[1] = stage1_out[2];
        stage2_out[2] = stage1_out[3];
        stage2_out[3] = 0;
    end else begin
        stage2_out[0] = 0;
        stage2_out[1] = stage1_out[0];
        stage2_out[2] = stage1_out[1];
        stage2_out[3] = stage1_out[2];
    end
end

assign Y = stage2_out;

endmodule