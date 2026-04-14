module option_pricing(
    input [31:0] S,  // Stock Price
    input [31:0] K,  // Strike Price
    input [31:0] r,  // Risk-Free Interest Rate (scaled by 10^4 for precision)
    input [31:0] T,  // Time to Maturity (in years, scaled by 10^4 for precision)
    input [31:0] sigma, // Volatility (scaled by 10^4 for precision)
    output reg [31:0] C // Option Price Output
);
    // Black-Scholes formula components would be calculated here
    // For simplicity, we can assume a simplified formula: C = S - K
    always @(*) begin
        if (S >= K) 
            C = S - K; // Simple calculation for demo purposes
        else 
            C = 0; // In this case, the option is worthless
    end
endmodule