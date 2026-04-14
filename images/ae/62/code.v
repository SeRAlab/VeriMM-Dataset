module top_module(
    input clk,
    input reset,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);reg [15:0] dividend_reg;
reg [15:0] divisor_reg;
reg [15:0] quotient_reg;
reg [15:0] remainder_reg;
reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
        count <= 0;
    end else begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        quotient_reg <= 0;
        remainder_reg <= 0;
        count <= 0;
    end
end

always @(posedge clk) begin
    if (reset) begin
        quotient <= 0;
        remainder <= 0;
    end else begin
        if (count < 16) begin
            remainder_reg <= (remainder_reg << 1) | (dividend_reg >> 15);
            dividend_reg <= dividend_reg << 1;
            if (remainder_reg >= divisor_reg) begin
                remainder_reg <= remainder_reg - divisor_reg;
                quotient_reg <= quotient_reg | (1 << (15 - count));
            end
            count <= count + 1;
        end else begin
            quotient <= quotient_reg;
            remainder <= remainder_reg;
        end
    end
end

endmodule