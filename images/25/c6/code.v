module chebyshev_filter(
    input [4:0] x, // 5-bit input
    output [4:0] y // 5-bit output
);
    // Coefficients for a 2nd order Chebyshev filter example (normalized)
    parameter b0 = 5'b00100; // Coefficient for x[n]
    parameter b1 = 5'b00010; // Coefficient for x[n-1]
    parameter b2 = 5'b00001; // Coefficient for x[n-2]
    parameter a1 = 5'b00011; // Feedback coefficient for y[n-1]
    parameter a2 = 5'b00001; // Feedback coefficient for y[n-2]
    
    reg [4:0] y_reg; // Internal register for output

    // Internal signals for previous inputs and outputs
    reg [4:0] x1, x2;
    reg [4:0] y1, y2;

    always @(*) begin
        // Shift previous input values
        x2 = x1; 
        x1 = x;

        // Calculate output
        y_reg = (b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2) >> 2; // Example normalization
    end

    assign y = y_reg;

endmodule