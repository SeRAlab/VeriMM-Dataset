module black_scholes_option_price (
    input [31:0] S,   // Current stock price
    input [31:0] K,   // Strike price
    input [31:0] r,   // Risk-free interest rate (as a percentage)
    input [31:0] T,   // Time to expiration (in years)
    input [31:0] sigma, // Volatility (as a percentage)
    output [31:0] C   // Option price output
);

    // Using a simplified model for demonstration, actual implementation would involve complex calculations
    // C = max(0, S - K) * exp(-r * T)
    
    wire [31:0] max_val;
    wire [31:0] discount_factor;
    
    assign max_val = (S > K) ? (S - K) : 32'b0; // max(0, S - K)
    assign discount_factor = (r * T) / 100; // Simplified discount factor calculation (not actual exp calculation)

    assign C = max_val - discount_factor; // Simplified option price calculation

endmodule