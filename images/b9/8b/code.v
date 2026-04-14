module top_module(
    input [3:0] A,
    input [3:0] B,
    input shift_left,
    input shift_right,
    output reg [3:0] result
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

always @(*) begin
    if (shift_left) begin
        stage1_out = A << B;
    end else if (shift_right) begin
        stage1_out = A >> B;
    end else begin
        stage1_out = A;
    end
end

always @(*) begin
    if (shift_left || shift_right) begin
        stage2_out = stage1_out;
    end else begin
        stage2_out = A;
    end
end

always @(*) begin
    result = stage2_out;
end

endmodule