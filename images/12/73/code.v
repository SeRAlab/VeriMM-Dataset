module fir_filter (
    input [3:0] x0, // current sample
    input [3:0] x1, // previous sample
    input [3:0] x2, // two samples ago
    input [3:0] x3, // three samples ago
    output [7:0] y  // output
);
    // Coefficients
    parameter c0 = 4'd1;
    parameter c1 = 4'd2;
    parameter c2 = 4'd3;
    parameter c3 = 4'd4;

    // FIR filter operation
    assign y = (c0 * x0) + (c1 * x1) + (c2 * x2) + (c3 * x3);
endmodule