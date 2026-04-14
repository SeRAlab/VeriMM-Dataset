module divider_4bit (
    input [3:0] A, // Dividend
    input [3:0] B, // Divisor
    output reg [3:0] Q, // Quotient
    output reg [3:0] R  // Remainder
);
    always @(*) begin
        if (B != 0) begin
            Q = A / B; // Perform division
            R = A % B; // Calculate remainder
        end else begin
            Q = 4'b0000; // If divisor is 0, set quotient to 0
            R = 4'b0000; // And remainder to 0
        end
    end
endmodule