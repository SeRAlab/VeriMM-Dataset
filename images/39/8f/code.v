module fir_filter (
    input wire signed [15:0] x0, // input sample 0
    input wire signed [15:0] x1, // input sample 1
    input wire signed [15:0] x2, // input sample 2
    input wire signed [15:0] x3, // input sample 3
    output wire signed [31:0] y   // output sample
);

    // Define filter coefficients
    parameter signed [15:0] h0 = 16'h0001; // Coefficient for x0
    parameter signed [15:0] h1 = 16'h0002; // Coefficient for x1
    parameter signed [15:0] h2 = 16'h0003; // Coefficient for x2
    parameter signed [15:0] h3 = 16'h0004; // Coefficient for x3

    // Calculate output
    assign y = (h0 * x0) + (h1 * x1) + (h2 * x2) + (h3 * x3);

endmodule