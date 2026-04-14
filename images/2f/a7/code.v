module fft_4_point (
    input [15:0] a_real, a_imag, // Input complex numbers (a_real + a_imag * j)
    input [15:0] b_real, b_imag,
    input [15:0] c_real, c_imag,
    input [15:0] d_real, d_imag,
    output [15:0] y0_real, y0_imag,
    output [15:0] y1_real, y1_imag,
    output [15:0] y2_real, y2_imag,
    output [15:0] y3_real, y3_imag
);
    // Intermediate calculations
    wire [15:0] w_real, w_imag; // Twiddle factor (e^(2pi/4 * k))
    assign w_real = 16'h0000; // For 4-point FFT, we can use the fact that w^0 = 1
    assign w_imag = 16'h0000;

    // FFT calculations
    assign y0_real = a_real + b_real + c_real + d_real;
    assign y0_imag = a_imag + b_imag + c_imag + d_imag;
    
    assign y1_real = a_real - b_real + (w_real * (c_real - d_real)) >> 1;
    assign y1_imag = a_imag - b_imag + (w_imag * (c_imag - d_imag)) >> 1;
    
    assign y2_real = a_real + b_real - (c_real + d_real);
    assign y2_imag = a_imag + b_imag - (c_imag + d_imag);
    
    assign y3_real = a_real - b_real - (w_real * (c_real - d_real)) >> 1;
    assign y3_imag = a_imag - b_imag - (w_imag * (c_imag - d_imag)) >> 1;

endmodule