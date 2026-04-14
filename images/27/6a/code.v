module chebyshev_filter (
    input [15:0] x,       // Input signal
    output reg [15:0] y   // Output signal
);
    // Coefficients for a 5th order Chebyshev filter (example coefficients)
    parameter [15:0] b0 = 16'h1F;  // Coefficient for x[n]
    parameter [15:0] b1 = 16'h1C;  // Coefficient for x[n-1]
    parameter [15:0] b2 = 16'h1A;  // Coefficient for x[n-2]
    parameter [15:0] b3 = 16'h15;  // Coefficient for x[n-3]
    parameter [15:0] b4 = 16'h10;  // Coefficient for x[n-4]
    parameter [15:0] b5 = 16'h0B;  // Coefficient for x[n-5]
    
    reg [15:0] past_samples [0:4];  // Array to hold past input samples
    
    always @(*) begin
        // Shift the past samples
        past_samples[0] = x;
        past_samples[1] = past_samples[0];
        past_samples[2] = past_samples[1];
        past_samples[3] = past_samples[2];
        past_samples[4] = past_samples[3];
        
        // Output calculation using Chebyshev filter coefficients
        y = b0 * past_samples[0] +
            b1 * past_samples[1] +
            b2 * past_samples[2] +
            b3 * past_samples[3] +
            b4 * past_samples[4] >> 4; // Right shift for scaling
    end
endmodule