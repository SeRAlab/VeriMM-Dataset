module SRT_Divider (
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);

always @(*) begin
    if (divisor == 16'b0) begin
        quotient = 16'b0; // Avoid division by zero
        remainder = dividend; // Remainder is the dividend
    end else begin
        quotient = dividend / divisor; // Simple integer division
        remainder = dividend % divisor; // Remainder
    end
end

endmodule