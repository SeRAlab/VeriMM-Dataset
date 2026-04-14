module fir_filter (
    input wire [7:0] x0, // Input sample 0
    input wire [7:0] x1, // Input sample 1
    input wire [7:0] x2, // Input sample 2
    input wire [7:0] x3, // Input sample 3
    output wire [15:0] y  // Output sample
);
    // Coefficients for 4-tap FIR filter
    parameter [7:0] h0 = 8'h1; // Coefficient for x0
    parameter [7:0] h1 = 8'h2; // Coefficient for x1
    parameter [7:0] h2 = 8'h3; // Coefficient for x2
    parameter [7:0] h3 = 8'h4; // Coefficient for x3

    // Calculate the output using the FIR filter equation
    assign y = (h0 * x0) + (h1 * x1) + (h2 * x2) + (h3 * x3);
endmodule