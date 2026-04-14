module fft_4point (
    input [7:0] a0, b0,
    input [7:0] a1, b1,
    input [7:0] a2, b2,
    input [7:0] a3, b3,
    output [7:0] c0_real, c0_imag,
    output [7:0] c1_real, c1_imag,
    output [7:0] c2_real, c2_imag,
    output [7:0] c3_real, c3_imag
);
    wire signed [8:0] w1_real, w1_imag, w2_real, w2_imag;
    wire signed [8:0] w3_real, w3_imag;

    // Twiddle factors
    assign w1_real = 8'b00000001; // cos(π/2)
    assign w1_imag = 8'b00000001; // sin(π/2)
    
    assign w2_real = 8'b00000000; // cos(π)
    assign w2_imag = 8'b00000001; // sin(π)
    
    assign w3_real = 8'b11111111; // cos(3π/2)
    assign w3_imag = 8'b00000001; // sin(3π/2)

    // FFT calculations
    assign c0_real = a0 + a1 + a2 + a3;
    assign c0_imag = b0 + b1 + b2 + b3;

    assign c1_real = a0 + (w1_real * a1 - w1_imag * b1) + (w2_real * a2 - w2_imag * b2) + (w3_real * a3 - w3_imag * b3);
    assign c1_imag = b0 + (w1_real * b1 + w1_imag * a1) + (w2_real * b2 + w2_imag * a2) + (w3_real * b3 + w3_imag * a3);
    
    assign c2_real = a0 - (w1_real * a1 - w1_imag * b1) + (w2_real * a2 - w2_imag * b2) - (w3_real * a3 - w3_imag * b3);
    assign c2_imag = b0 - (w1_real * b1 + w1_imag * a1) + (w2_real * b2 + w2_imag * a2) - (w3_real * b3 + w3_imag * a3);
    
    assign c3_real = a0 - a1 + a2 - a3;
    assign c3_imag = b0 - b1 + b2 - b3;
endmodule