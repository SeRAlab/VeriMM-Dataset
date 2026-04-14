module add4bits (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S
);

    reg [4:0] sum; // Declare a 5-bit register to handle overflow

    always @* begin
        sum = A + B; // Perform addition
        if (sum > 15) // Check for overflow
            S = sum[3:0]; // Drop the most significant bit
        else
            S = sum[3:0]; // No overflow, output the sum
    end

endmodule