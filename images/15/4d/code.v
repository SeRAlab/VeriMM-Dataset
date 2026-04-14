module chebyshev_filter (
    input [3:0] x,       // 4-bit input signal
    output reg [7:0] y   // 8-bit output signal
);

    // Chebyshev filter coefficients (example values)
    parameter a0 = 8'd1; // Coefficient for x[n] (input)
    parameter a1 = 8'd2; // Coefficient for x[n-1]
    parameter a2 = 8'd1; // Coefficient for x[n-2]
    
    always @(*) begin
        y = (a0 * x) + (a1 * (x >> 1)) + (a2 * (x >> 2)); // Simple filter implementation
    end
endmodule