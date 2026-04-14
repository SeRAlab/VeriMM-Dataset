module fir_filter (
    input [3:0] x, // 4-bit input signal
    output [3:0] y // 4-bit output signal
);
    // Coefficients for the FIR filter (for example)
    parameter [3:0] h0 = 4'b0001;
    parameter [3:0] h1 = 4'b0010;
    parameter [3:0] h2 = 4'b0011;
    parameter [3:0] h3 = 4'b0100;

    // Compute the output as a weighted sum of input taps
    assign y = (h0 * x) + (h1 * x) + (h2 * x) + (h3 * x);
endmodule