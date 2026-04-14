module srt_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);

always @(*) begin
    if (divisor == 0) begin
        quotient = 4'b0000; // Handle divide by zero
        remainder = dividend; // Remainder is the dividend
    end else begin
        quotient = dividend / divisor; // Integer division
        remainder = dividend % divisor; // Remainder
    end
end

endmodule