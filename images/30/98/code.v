module black_scholes_call_option(  
    input [31:0] S, // Current stock price  
    input [31:0] K, // Strike price  
    input [31:0] T, // Time to expiration (in years)  
    input [31:0] r, // Risk-free interest rate  
    input [31:0] sigma, // Volatility  
    output reg [31:0] C // Call option price  
);  
    always @(*) begin  
        // Using a simple approximation for the Black-Scholes formula  
        // C = S * N(d1) - K * exp(-r * T) * N(d2)  
        // Note: Actual implementation would require calculating N(d1) and N(d2)  
        
        // Dummy calculation for example purposes  
        C = S - K; // Simplified option price calculation  
    end  
endmodule