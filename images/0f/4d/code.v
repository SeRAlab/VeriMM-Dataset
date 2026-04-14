module srt_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 8'b0; // Division by zero case
            remainder = dividend; // Remainder is the dividend
        end else begin
            quotient = dividend / divisor; // Perform the division
            remainder = dividend % divisor; // Get the remainder
        end
    end
endmodule