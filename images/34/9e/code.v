module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 2'b00; // Division by zero case, return 0
            remainder = dividend; // Remainder is the dividend
        end else begin
            quotient = dividend / divisor; // Standard integer division
            remainder = dividend % divisor; // Standard modulo operation
        end
    end
endmodule