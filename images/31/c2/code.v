module fir_filter (
    input [3:0] x0, // current input
    input [3:0] x1, // previous input
    input [3:0] x2, // two inputs ago
    input [3:0] x3, // three inputs ago
    output [7:0] y // output
);
    // FIR filter coefficients
    parameter [3:0] h0 = 4'd1;
    parameter [3:0] h1 = 4'd2;
    parameter [3:0] h2 = 4'd3;
    parameter [3:0] h3 = 4'd4;

    // Output calculation
    assign y = (x0 * h0) + (x1 * h1) + (x2 * h2) + (x3 * h3);
endmodule