module fir_filter (
    input [7:0] x0, x1, x2, x3, // 4 input samples
    output [15:0] y            // Output
);
    // Coefficients
    parameter c0 = 1;
    parameter c1 = 2;
    parameter c2 = 3;
    parameter c3 = 4;

    assign y = c0 * x0 + c1 * x1 + c2 * x2 + c3 * x3;
endmodule