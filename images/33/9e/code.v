module fft_4point (
    input [7:0] x0_re, input [7:0] x0_im,
    input [7:0] x1_re, input [7:0] x1_im,
    input [7:0] x2_re, input [7:0] x2_im,
    input [7:0] x3_re, input [7:0] x3_im,
    output [7:0] y0_re, output [7:0] y0_im,
    output [7:0] y1_re, output [7:0] y1_im,
    output [7:0] y2_re, output [7:0] y2_im,
    output [7:0] y3_re, output [7:0] y3_im
);
    // Intermediate variables
    wire [7:0] w1_re, w1_im, w2_re, w2_im;
    
    // Twiddle factors for the FFT
    assign w1_re = 8'h00; // cos(pi/2) = 0
    assign w1_im = 8'hFF; // sin(pi/2) = -1
    assign w2_re = 8'h00; // cos(pi) = -1
    assign w2_im = 8'h00; // sin(pi) = 0

    // FFT computations
    assign y0_re = x0_re + x1_re + x2_re + x3_re;
    assign y0_im = x0_im + x1_im + x2_im + x3_im;
    
    assign y1_re = x0_re + (w1_re * x1_re - w1_im * x1_im) + (w2_re * x2_re - w2_im * x2_im) + (w1_re * x3_re - w1_im * x3_im);
    assign y1_im = x0_im + (w1_re * x1_im + w1_im * x1_re) + (w2_re * x2_im + w2_im * x2_re) + (w1_re * x3_im + w1_im * x3_re);

    assign y2_re = x0_re + (w2_re * x1_re - w2_im * x1_im) + (w1_re * x2_re - w1_im * x2_im) + (w2_re * x3_re - w2_im * x3_im);
    assign y2_im = x0_im + (w2_re * x1_im + w2_im * x1_re) + (w1_re * x2_im + w1_im * x2_re) + (w2_re * x3_im + w2_im * x3_re);

    assign y3_re = x0_re + (w1_im * x1_re + w1_re * x1_im) + (w2_im * x2_re + w2_re * x2_im) + (w1_im * x3_re + w1_re * x3_im);
    assign y3_im = x0_im + (w1_im * x1_im - w1_re * x1_re) + (w2_im * x2_im - w2_re * x2_re) + (w1_im * x3_im - w1_re * x3_re);
    
endmodule