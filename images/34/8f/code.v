module divider_2bit(
    input [1:0] A,   // Dividend
    input [1:0] B,   // Divisor
    output reg [1:0] Q, // Quotient
    output reg [1:0] R  // Remainder
);
    always @(*) begin
        if (B == 2'b00) begin
            Q = 2'b11; // Error condition: Division by zero
            R = 2'b11; // Error condition: Division by zero
        end else begin
            Q = A / B; // Perform integer division
            R = A % B; // Calculate remainder
        end
    end
endmodule