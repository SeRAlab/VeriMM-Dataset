module black_scholes (
    input [7:0] S,
    input [7:0] K,
    input [7:0] T,
    input [7:0] r,
    input [7:0] sigma,
    output reg [15:0] option_price
);
    // Implementation details of the Black-Scholes model will go here
    // For simplicity, we will assume a simplified calculation without actual N(d1) or N(d2) functions.
    always @(*) begin
        // This is a placeholder for the option price calculation logic
        // In actual implementation, you would need to calculate N(d1) and N(d2)
        
        // Placeholder calculation for the purpose of this example
        option_price = (S * 2 - K) + (r * T) + (sigma * 100); // Simplified
    end
endmodule