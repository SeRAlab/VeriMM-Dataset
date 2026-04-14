module top_module(
    input [3:0] A,
    input [3:0] B,
    input Sub,
    output [3:0] Sum,
    output Overflow
);reg [3:0] temp_sum;
    reg temp_overflow;

    always @(*) begin
        if (Sub == 1) begin
            temp_sum = A - B;
            if (A[3] == 1 && B[3] == 0 && temp_sum[3] == 0) begin
                temp_overflow = 1;
            end else if (A[3] == 0 && B[3] == 1 && temp_sum[3] == 1) begin
                temp_overflow = 1;
            end else begin
                temp_overflow = 0;
            end
        end else begin
            temp_sum = A + B;
            if (A[3] == 0 && B[3] == 0 && temp_sum[3] == 1) begin
                temp_overflow = 1;
            end else if (A[3] == 1 && B[3] == 1 && temp_sum[3] == 0) begin
                temp_overflow = 1;
            end else begin
                temp_overflow = 0;
            end
        end
    end

    assign Sum = temp_sum;
    assign Overflow = temp_overflow;

endmodule