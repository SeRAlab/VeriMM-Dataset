module fft_4point (
    input [15:0] a_real, a_imag,
    input [15:0] b_real, b_imag,
    input [15:0] c_real, c_imag,
    input [15:0] d_real, d_imag,
    output [15:0] out0_real, out0_imag,
    output [15:0] out1_real, out1_imag,
    output [15:0] out2_real, out2_imag,
    output [15:0] out3_real, out3_imag
);
    // FFT Implementation
    wire signed [16:0] w1_real, w1_imag, w2_real, w2_imag;
    wire signed [16:0] sum_real, sum_imag, diff_real, diff_imag;

    // Twiddle factors for 4-point FFT
    assign w1_real = 16'h0000;  // cos(0) = 1
    assign w1_imag = 16'hFFFF;  // sin(0) = 0
    assign w2_real = 16'h0000;   // cos(-pi/2) = 0
    assign w2_imag = 16'h8000;  // sin(-pi/2) = -1

    // Stage 1
    assign sum_real = a_real + b_real;
    assign sum_imag = a_imag + b_imag;
    assign diff_real = a_real - b_real;
    assign diff_imag = a_imag - b_imag;

    // Stage 2
    assign out0_real = sum_real + (w2_real * c_real - w2_imag * c_imag) >>> 15;
    assign out0_imag = sum_imag + (w2_real * c_imag + w2_imag * c_real) >>> 15;
    assign out1_real = diff_real + (w2_real * d_real - w2_imag * d_imag) >>> 15;
    assign out1_imag = diff_imag + (w2_real * d_imag + w2_imag * d_real) >>> 15;
    assign out2_real = sum_real - (w2_real * c_real - w2_imag * c_imag) >>> 15;
    assign out2_imag = sum_imag - (w2_real * c_imag + w2_imag * c_real) >>> 15;
    assign out3_real = diff_real - (w2_real * d_real - w2_imag * d_imag) >>> 15;
    assign out3_imag = diff_imag - (w2_real * d_imag + w2_imag * d_real) >>> 15;

endmodule