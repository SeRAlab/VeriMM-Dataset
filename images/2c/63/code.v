module divider_4bit (
    input [3:0] A, // Dividend
    input [3:0] B, // Divisor
    output reg [3:0] Q, // Quotient
    output reg [3:0] R  // Remainder
);
    always @(*) begin
        if (B == 4'b0000) begin
            Q = 4'b0000; // Set quotient to 0 if divisor is 0
            R = 4'b0000; // Set remainder to 0 if divisor is 0
        end else begin
            Q = A / B; // Perform division
            R = A % B; // Get remainder
        end
    end
endmodule