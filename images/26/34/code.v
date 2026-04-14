module fir_filter (
    input [7:0] x0, // Input sample 0
    input [7:0] x1, // Input sample 1
    input [7:0] x2, // Input sample 2
    output [15:0] y  // Output sample
);
    // Coefficients
    parameter signed [7:0] h0 = 1;
    parameter signed [7:0] h1 = 2;
    parameter signed [7:0] h2 = 1;

    // Compute the output
    assign y = (h0 * x0) + (h1 * x1) + (h2 * x2);
endmodule