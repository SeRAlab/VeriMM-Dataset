module top_module(
    input clk,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);reg [3:0] dividend_reg;
reg [3:0] divisor_reg;
reg [3:0] quotient_reg;
reg [3:0] remainder_reg;
reg [2:0] count; // changed to 3 bits to hold values 0-4

always @* begin // Use the combinational block here for reset logic
    dividend_reg = dividend;
    divisor_reg = divisor;
    quotient_reg = 0;
    remainder_reg = 0;
    count = 4; // Initialize count to 4
end

always @ (posedge clk) begin
    if (divisor_reg != 0) begin
        if (count > 0) begin
            remainder_reg <= {remainder_reg[2:0], dividend_reg[3]};
            dividend_reg <= {dividend_reg[2:0], 1'b0};
            quotient_reg <= {quotient_reg[2:0], ~remainder_reg[3]};
            count <= count - 1;
        end else begin
            // Assign final values after the count has reached 0
            quotient <= quotient_reg;
            remainder <= remainder_reg;
        end
    end
end

endmodule