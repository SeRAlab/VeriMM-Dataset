module divider_2bit (
    input [1:0] A,  // 2-bit dividend
    input [1:0] B,  // 2-bit divisor
    output reg [1:0] Q,  // 2-bit quotient
    output reg [1:0] R   // 2-bit remainder
);
    always @(*) begin
        if (B == 2'b00) begin
            Q = 2'b00;  // Division by zero case
            R = A;      // Remainder is the dividend
        end else begin
            Q = A / B;  // Compute quotient
            R = A % B;  // Compute remainder
        end
    end
endmodule