module divider_2bit (
    input [1:0] A, // Dividend
    input [1:0] B, // Divisor
    output reg [1:0] Q, // Quotient
    output reg [1:0] R // Remainder
);
    always @(*) begin
        if (B == 2'b00) begin
            Q = 2'b00; // Handle division by zero
            R = 2'b00;
        end else begin
            Q = A / B; // Compute quotient
            R = A % B; // Compute remainder
        end
    end
endmodule