module top_module(
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);reg [7:0] dividend_reg;
reg [3:0] divisor_reg;
reg [3:0] quotient_reg;
reg [3:0] remainder_reg;
reg [2:0] state;

always @(*) begin
    case(state)
        3'b000: begin // Load dividend and divisor
            dividend_reg = {dividend, 4'b0};
            divisor_reg = {divisor, 4'b0};
            quotient_reg = 4'b0;
            remainder_reg = dividend_reg;
            state = 3'b001;
        end
        3'b001: begin // Shift left divisor and quotient
            divisor_reg = {divisor_reg[2:0], 1'b0};
            quotient_reg = {quotient_reg[2:0], 1'b0};
            state = 3'b010;
        end
        3'b010: begin // Subtract divisor from remainder
            remainder_reg = remainder_reg - divisor_reg;
            if (remainder_reg[7] == 1) begin // If remainder is negative, add divisor back
                remainder_reg = remainder_reg + divisor_reg;
                quotient_reg[0] = 0;
            end else begin
                quotient_reg[0] = 1;
            end
            state = 3'b011;
        end
        3'b011: begin // Shift right divisor and quotient
            divisor_reg = {1'b0, divisor_reg[3:1]};
            quotient_reg = {1'b0, quotient_reg[3:1]};
            state = (divisor_reg == 4'b0001) ? 3'b100 : 3'b001;
        end
        3'b100: begin // Done
            quotient = quotient_reg;
            remainder = remainder_reg[3:0];
            state = 3'b000;
        end
    endcase
end

endmodule