module top_module(
    input clk,
    input reset,
    input signed [15:0] dividend,
    input signed [15:0] divisor,
    output reg signed [15:0] quotient,
    output reg signed [15:0] remainder,
    output reg signed [15:0] final_output
);reg signed [15:0] dividend_reg;
reg signed [15:0] divisor_reg;
reg signed [15:0] quotient_reg;
reg signed [15:0] remainder_reg;
reg [4:0] count;

always @(posedge clk) begin
    if (reset) begin
        dividend_reg <= 16'b0;
        divisor_reg <= 16'b0;
        quotient_reg <= 16'b0;
        remainder_reg <= 16'b0;
        count <= 5'b0;
    end else begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (count < 5) begin
            quotient_reg[count] <= dividend_reg[15];
            dividend_reg <= {dividend_reg[14:0], remainder_reg[15]};
            remainder_reg <= {remainder_reg[14:0], dividend_reg[15]};
            count <= count + 1;
        end else begin
            if (remainder_reg < 0) begin
                remainder_reg <= remainder_reg + divisor_reg;
                quotient_reg[15] <= 1'b0;
            end else begin
                remainder_reg <= remainder_reg - divisor_reg;
                quotient_reg[15] <= 1'b1;
            end
            quotient_reg[14:0] <= quotient_reg[13:0];
            quotient_reg[0] <= remainder_reg[15];
            remainder_reg <= {remainder_reg[14:0], quotient_reg[15]};
            count <= count + 1;
        end
    end
end

always @(posedge clk) begin
    if (reset) begin
        quotient <= 16'b0;
        remainder <= 16'b0;
        final_output <= 16'b0;
    end else begin
        quotient <= quotient_reg;
        remainder <= remainder_reg;
        final_output <= {quotient_reg, remainder_reg} / divisor_reg;
    end
end

endmodule