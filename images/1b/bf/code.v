module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b00; // Division by zero case
            remainder = dividend; // Remainder is the dividend
        end else begin
            quotient = dividend / divisor; // Calculate the quotient
            remainder = dividend % divisor; // Calculate the remainder
        end
    end
endmodule