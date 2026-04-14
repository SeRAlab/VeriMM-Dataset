module top_module(
    input clk, // Added clk input
    input [7:0] DIVIDEND,
    input [7:0] DIVISOR,
    output reg [7:0] QUOTIENT,
    output reg [7:0] REMAINDER
);reg [7:0] dividend_reg;
reg [7:0] divisor_reg;
reg [7:0] quotient_reg;
reg [7:0] remainder_reg;

reg [3:0] state;
parameter [3:0] IDLE = 4'b0000;
parameter [3:0] SHIFT = 4'b0001;
parameter [3:0] COMPARE = 4'b0010;
parameter [3:0] SUBTRACT = 4'b0011;
parameter [3:0] OUTPUT = 4'b0100;

always @(posedge clk) begin
    case (state)
        IDLE: begin
            dividend_reg <= DIVIDEND;
            divisor_reg <= DIVISOR;
            quotient_reg <= 8'b0;
            remainder_reg <= 8'b0;
            state <= SHIFT;
        end
        SHIFT: begin
            dividend_reg <= {dividend_reg[6:0], 1'b0};
            quotient_reg <= {quotient_reg[6:0], dividend_reg[7]};
            state <= COMPARE;
        end
        COMPARE: begin
            if (dividend_reg >= divisor_reg) begin
                state <= SUBTRACT;
            end else begin
                state <= SHIFT;
            end
        end
        SUBTRACT: begin
            dividend_reg <= dividend_reg - divisor_reg;
            remainder_reg <= dividend_reg;
            state <= OUTPUT;
        end
        OUTPUT: begin
            QUOTIENT <= quotient_reg;
            REMAINDER <= remainder_reg;
            state <= IDLE;
        end
    endcase
end

endmodule