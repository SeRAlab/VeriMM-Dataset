module srt_divider(
    input [4:0] dividend,
    input [4:0] divisor,
    output reg [4:0] quotient,
    output reg [4:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 5'b0; // Division by zero handling
            remainder = dividend; // Remainder is the dividend
        end else begin
            quotient = dividend / divisor; // Quotient calculation
            remainder = dividend % divisor; // Remainder calculation
        end
    end
endmodule