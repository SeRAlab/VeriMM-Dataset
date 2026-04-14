module butterworth_filter (
    input [4:0] x, // 5-bit input
    output [4:0] y // 5-bit output
);
    // Coefficients for a simple 2nd-order Butterworth filter
    parameter b0 = 5'b00001; // Coefficient for x[n]
    parameter b1 = 5'b00010; // Coefficient for x[n-1]
    parameter b2 = 5'b00100; // Coefficient for x[n-2]
    parameter a1 = 5'b00001; // Coefficient for y[n-1]
    parameter a2 = 5'b00010; // Coefficient for y[n-2]

    reg [4:0] y_reg;
    reg [4:0] x_reg [0:2]; // Shift register for past inputs

    always @(*) begin
        // Update shift register
        x_reg[0] = x; // Current input
        x_reg[1] = x_reg[0]; // Previous input
        x_reg[2] = x_reg[1]; // Input before previous

        // Simple filter equation (output)
        y_reg = (b0 * x_reg[0] + b1 * x_reg[1] + b2 * x_reg[2]) >> 2; // Adjusted for fixed-point
    end

    assign y = y_reg;
endmodule