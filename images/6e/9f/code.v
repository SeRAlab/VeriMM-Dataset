module top_module(
    input signed [3:0] A, B,
    input carry_in,
    output signed [3:0] sum,
    output overflow
);reg signed [3:0] temp_sum;
    reg temp_overflow;

    always @(*) begin
        temp_sum = A + B + carry_in;
        if (temp_sum > 7 || temp_sum < -8) begin
            temp_overflow = 1;
        end else begin
            temp_overflow = 0;
        end
    end

    assign sum = temp_sum;
    assign overflow = temp_overflow;

endmodule