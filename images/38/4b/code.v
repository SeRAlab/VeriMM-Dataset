module fft_4_point (
    input [7:0] x0_real,
    input [7:0] x0_imag,
    input [7:0] x1_real,
    input [7:0] x1_imag,
    input [7:0] x2_real,
    input [7:0] x2_imag,
    input [7:0] x3_real,
    input [7:0] x3_imag,
    output [7:0] y0_real,
    output [7:0] y0_imag,
    output [7:0] y1_real,
    output [7:0] y1_imag,
    output [7:0] y2_real,
    output [7:0] y2_imag,
    output [7:0] y3_real,
    output [7:0] y3_imag
);
    wire signed [8:0] w1_real, w1_imag, w2_real, w2_imag, w3_real, w3_imag;
    
    // Twiddle factors
    assign w1_real = 8'd128;   // cos(π/2)
    assign w1_imag = -8'd128;  // -sin(π/2)
    assign w2_real = 8'd0;      // cos(π)
    assign w2_imag = -8'd0;     // -sin(π)
    assign w3_real = -8'd128;   // cos(3π/2)
    assign w3_imag = -8'd128;   // -sin(3π/2)

    // FFT calculations
    assign y0_real = x0_real + x1_real + x2_real + x3_real;
    assign y0_imag = x0_imag + x1_imag + x2_imag + x3_imag;

    assign y1_real = x0_real + (w1_real * x1_real - w1_imag * x1_imag) >> 7;
    assign y1_imag = x0_imag + (w1_real * x1_imag + w1_imag * x1_real) >> 7;

    assign y2_real = x0_real + (w2_real * x2_real - w2_imag * x2_imag) >> 7;
    assign y2_imag = x0_imag + (w2_real * x2_imag + w2_imag * x2_real) >> 7;

    assign y3_real = x0_real + (w3_real * x3_real - w3_imag * x3_imag) >> 7;
    assign y3_imag = x0_imag + (w3_real * x3_imag + w3_imag * x3_real) >> 7;

endmodule