module divider_2bit (
    input [1:0] A, // Numerator
    input [1:0] B, // Denominator
    output reg [1:0] quotient, // Quotient
    output reg [1:0] remainder // Remainder
);
    always @(*) begin
        if (B == 2'b00) begin
            quotient = 2'b00; // Undefined behavior, can also set to a specific value
            remainder = 2'b00; // Undefined behavior
        end else begin
            quotient = A / B;
            remainder = A % B;
        end
    end
endmodule