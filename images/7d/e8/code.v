module top_module(
    input signed [15:0] dividend,
    input signed [15:0] divisor,
    output signed [15:0] quotient,
    output signed [15:0] remainder,
    output divide_by_zero
);reg signed [15:0] dividend_reg;
    reg signed [15:0] divisor_reg;
    reg signed [15:0] quotient_reg;
    reg signed [15:0] remainder_reg;
    reg divide_by_zero_reg;

    always @(*) begin
        divide_by_zero_reg = 0;
        if (divisor == 0) begin
            divide_by_zero_reg = 1;
            quotient_reg = 0;
            remainder_reg = 0;
        end else begin
            dividend_reg = dividend;
            divisor_reg = divisor;
            if (dividend_reg < 0) begin
                dividend_reg = -dividend_reg;
                divisor_reg = -divisor_reg;
            end
            quotient_reg = dividend_reg / divisor_reg;
            remainder_reg = dividend_reg % divisor_reg;
            if (dividend < 0) begin
                quotient_reg = -quotient_reg;
                remainder_reg = -remainder_reg;
            end
        end
    end

    assign quotient = quotient_reg;
    assign remainder = remainder_reg;
    assign divide_by_zero = divide_by_zero_reg;

endmodule