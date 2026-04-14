module SRT_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor != 0) begin
            quotient = dividend / divisor; // Integer division
            remainder = dividend % divisor; // Remainder
        end else begin
            quotient = 8'b0; // Define behavior for division by zero
            remainder = 8'b0; // Define behavior for division by zero
        end
    end
endmodule