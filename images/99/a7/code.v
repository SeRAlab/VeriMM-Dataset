module top_module(
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,          // Added clk as an input to fix the error
    output reg [3:0] quotient,
    output reg [3:0] remainder
);reg [7:0] dividend_reg;
reg [4:0] divisor_reg;  // changed to 5 bits to accommodate shifts
reg [3:0] quotient_reg;
reg [7:0] remainder_reg; // changed to 8 bits to accommodate shifts
reg [2:0] count;

always @(*) begin
    dividend_reg = {dividend, 4'b0};
    divisor_reg = {divisor, 1'b0}; // fixed the number of bits to accommodate shift
    quotient_reg = 4'b0;
    remainder_reg = dividend_reg;
    count = 3'd0; // fixed to 3 bits 
end

always @(posedge clk) begin
    if (count < 3'd4) begin // fixed the bit width to match count
        remainder_reg = {remainder_reg[6:0], quotient_reg[3]}; // left shift and update
        quotient_reg = {quotient_reg[2:0], 1'b0}; // left shift to add a new bit

        if (remainder_reg >= divisor_reg) begin
            remainder_reg = remainder_reg - divisor_reg;
            quotient_reg[0] = 1'b1; // set the lowest bit of quotient
        end
        count = count + 1'b1; // increment count
    end
end

assign quotient = quotient_reg;
assign remainder = remainder_reg[3:0]; // Only 4 bits used for remainder

endmodule