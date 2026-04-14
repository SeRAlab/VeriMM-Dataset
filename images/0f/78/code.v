module chebyshev_filter (
    input [4:0] x, // 5-bit input signal
    output reg [4:0] y // 5-bit output signal
);
    // Coefficients for the Chebyshev filter
    parameter a0 = 5'b00001; // Coefficient for x[n]
    parameter a1 = 5'b00010; // Coefficient for x[n-1]
    parameter a2 = 5'b00011; // Coefficient for x[n-2]

    // Filter implementation
    always @* begin
        y = (a0 * x) + (a1 * (x >> 1)) + (a2 * (x >> 2)); // Simple filter equation
    end
endmodule