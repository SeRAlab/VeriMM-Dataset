module top_module(
    input signed [15:0] A,
    input signed [15:0] B,
    output signed [31:0] result
);reg signed [31:0] temp_result;
reg sign;

always @(*) begin
    if (A[15] == 1 && B[15] == 1) begin
        temp_result = ~(A[15:0] * B[15:0]) + 1;
        sign = 0;
    end
    else if (A[15] == 1) begin
        temp_result = -A[15:0] * B[15:0];
        sign = 1;
    end
    else if (B[15] == 1) begin
        temp_result = -B[15:0] * A[15:0];
        sign = 1;
    end
    else begin
        temp_result = A[15:0] * B[15:0];
        sign = 0;
    end
end

assign result = (sign == 1) ? -temp_result : temp_result;

endmodule