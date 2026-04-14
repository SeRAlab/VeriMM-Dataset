module butterworth_filter (
    input [4:0] x,     // 5-bit input
    output reg [4:0] y // 5-bit output
);
    // Coefficients for 2nd-order Butterworth filter
    parameter A0 = 5'b00010; // Coefficient for x[n]
    parameter A1 = 5'b00001; // Coefficient for x[n-1]
    parameter A2 = 5'b00001; // Coefficient for x[n-2]

    reg [4:0] x_prev1, x_prev2;

    always @(*) begin
        // Shift previous values
        x_prev2 = x_prev1;
        x_prev1 = x;

        // Calculate output using fixed coefficients
        y = (A0 * x + A1 * x_prev1 + A2 * x_prev2) >> 1; // Right shift for fixed-point representation
    end
endmodule