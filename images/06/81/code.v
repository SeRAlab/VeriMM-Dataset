module SRT_Divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    always @(*) begin
        if (divisor == 4'b0000) begin
            quotient = 4'b0000; // Handle division by zero
            remainder = dividend; // Remainder is the dividend
            valid = 1'b0; // Not valid
        end else begin
            quotient = dividend / divisor; // Simple integer division
            remainder = dividend % divisor; // Remainder calculation
            valid = 1'b1; // Valid result
        end
    end
endmodule