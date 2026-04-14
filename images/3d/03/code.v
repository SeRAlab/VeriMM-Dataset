module chebyshev_filter (
    input [4:0] x,    // 5-bit input signal
    output reg [4:0] y // 5-bit output signal
);
    // Coefficients for a 2nd-order Chebyshev filter
    parameter a0 = 5'b00001; // Coefficient for x[n]
    parameter a1 = 5'b00010; // Coefficient for x[n-1]
    parameter a2 = 5'b00011; // Coefficient for x[n-2]
    
    reg [4:0] x1, x2; // Delayed inputs

    always @(*) begin
        // Shift the input values for delay
        x2 = x1; // x[n-2] = previous x[n-1]
        x1 = x;  // x[n-1] = current x[n]
        
        // Output calculation based on Chebyshev filter formula
        y = (a0 * x) + (a1 * x1) + (a2 * x2);
    end
endmodule