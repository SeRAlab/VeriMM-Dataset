module divider_2bit (
    input [1:0] A, // Dividend
    input [1:0] B, // Divisor
    output reg [1:0] Q, // Quotient
    output reg [1:0] R  // Remainder
);
    
    always @(*) begin
        if (B == 2'b00) begin // Division by zero
            Q = 2'b00; // Undefined behavior, return 0
            R = 2'b00; // Undefined behavior, return 0
        end else begin
            Q = A / B; // Perform division
            R = A % B; // Calculate remainder
        end
    end

endmodule