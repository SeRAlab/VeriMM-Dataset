module black_scholes(
    input [15:0] S,      // Stock price
    input [15:0] K,      // Strike price
    input [15:0] r,      // Risk-free interest rate
    input [15:0] t,      // Time to expiration
    input [15:0] sigma,   // Volatility
    output reg [31:0] C   // Option price output
);

    always @(*) begin
        // Simplified Black-Scholes formula for demonstration
        // C = S * N(d1) - K * exp(-r * t) * N(d2)
        // This is a placeholder; actual implementation would need N(d1) and N(d2) calculations
        C = (S * 2 - K * (r + t)); // Not the actual formula, for educational purposes
    end
endmodule