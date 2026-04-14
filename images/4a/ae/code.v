module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output signed [3:0] sum,
    output overflow
);reg signed [3:0] temp_sum;
    reg overflow_flag;

    always @(*) begin
        temp_sum = A + B;
        if (temp_sum > 7 || temp_sum < -8) begin
            overflow_flag = 1;
        end else begin
            overflow_flag = 0;
        end
    end

    assign sum = temp_sum;

endmodule