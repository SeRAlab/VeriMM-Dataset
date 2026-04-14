module fir_filter(
    input wire [7:0] x0,
    input wire [7:0] x1,
    input wire [7:0] x2,
    input wire [7:0] x3,
    output wire [15:0] y
);
    // Coefficients for the 4-tap FIR filter
    parameter [7:0] h0 = 8'h1A; // Coefficient for x0
    parameter [7:0] h1 = 8'h2B; // Coefficient for x1
    parameter [7:0] h2 = 8'h3C; // Coefficient for x2
    parameter [7:0] h3 = 8'h4D; // Coefficient for x3

    assign y = (h0 * x0) + (h1 * x1) + (h2 * x2) + (h3 * x3);
endmodule