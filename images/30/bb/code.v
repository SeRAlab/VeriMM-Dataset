module black_scholes(
    input [31:0] S, // Stock Price
    input [31:0] K, // Strike Price
    input [31:0] r, // Risk-free interest rate (scaled)
    input [31:0] sigma, // Volatility (scaled)
    input [31:0] T, // Time to expiration (scaled)
    output reg [63:0] C // Option Price
);

    // Simplified calculation for demonstration purposes (not the actual Black-Scholes formula)
    // C = S * exp(-r * T) - K * exp(-r * T)
    always @(*) begin
        C = (S * (2**10 / (1 + r))) - K * (2**10 / (1 + r)); // Using fixed-point arithmetic
    end
endmodule