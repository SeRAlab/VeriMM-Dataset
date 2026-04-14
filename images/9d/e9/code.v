module top_module(
    input [3:0] A,
    input [1:0] S,
    output [3:0] B
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if(S[1] == 0) begin // left shift
        stage1_out[0] = A[1];
        stage1_out[1] = A[2];
        stage1_out[2] = A[3];
        stage1_out[3] = A[0];
    end else begin // right shift
        stage1_out[0] = A[3];
        stage1_out[1] = A[0];
        stage1_out[2] = A[1];
        stage1_out[3] = A[2];
    end
end

always @(*) begin
    if(S[0] == 0) begin // no shift
        stage2_out = stage1_out;
    end else if(S[1] == 0) begin // left shift
        stage2_out[0] = stage1_out[2];
        stage2_out[1] = stage1_out[3];
        stage2_out[2] = stage1_out[0];
        stage2_out[3] = stage1_out[1];
    end else begin // right shift
        stage2_out[0] = stage1_out[1];
        stage2_out[1] = stage1_out[2];
        stage2_out[2] = stage1_out[3];
        stage2_out[3] = stage1_out[0];
    end
end

assign B = stage2_out;

endmodule