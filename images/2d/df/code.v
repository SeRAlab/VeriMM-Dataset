module two_bit_divider (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b11; // error code for division by zero
            remainder = 2'b11; // error code for division by zero
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule