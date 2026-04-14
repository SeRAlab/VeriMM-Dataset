module two_bit_divider(
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (divisor != 2'b00) begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end else begin
            quotient = 2'b00;  // Define behavior for divide by zero
            remainder = 2'b00;
        end
    end
endmodule