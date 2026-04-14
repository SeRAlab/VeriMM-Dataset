module top_module(
    input clk,
    input reset,
    input [3:0] dividend,
    input [3:0] divisor,
    input [2:0] selector,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg [7:0] Y
);// Binary division module
reg [3:0] dividend_reg;
reg [3:0] divisor_reg;
reg [3:0] quotient_reg;
reg [3:0] remainder_reg;
reg [2:0] count_reg; // Change the width to match usage

always @(posedge clk) begin
    if (reset) begin
        dividend_reg <= 0;
        divisor_reg <= 0;
        quotient_reg <= 0;
        remainder_reg <= 0;
        count_reg <= 0;
    end else begin
        dividend_reg <= dividend;
        divisor_reg <= divisor;
        if (selector == 0) begin
            if (divisor == 0) begin
                quotient_reg <= 0;
                remainder_reg <= 0;
            end else begin
                quotient_reg <= 0;
                remainder_reg <= dividend;
                for (count_reg = 0; count_reg < 4; count_reg = count_reg + 1) begin
                    remainder_reg <= remainder_reg << 1;
                    quotient_reg <= quotient_reg << 1;
                    if (remainder_reg >= divisor_reg) begin
                        remainder_reg <= remainder_reg - divisor_reg;
                        quotient_reg <= quotient_reg | 1;
                    end
                end
            end
        end
    end
end

assign quotient = quotient_reg;
assign remainder = remainder_reg;

// 3-to-8 decoder module
always @(*) begin
    case (selector) // Fixing the signals to use the selector input directly
        3'b000: Y = 8'b00000001;
        3'b001: Y = 8'b00000010;
        3'b010: Y = 8'b00000100;
        3'b011: Y = 8'b00001000;
        3'b100: Y = 8'b00010000;
        3'b101: Y = 8'b00100000;
        3'b110: Y = 8'b01000000;
        3'b111: Y = 8'b10000000;
        default: Y = 8'b00000000;
    endcase
end

endmodule