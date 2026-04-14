module fft_4point (
    input [15:0] x0_re, x0_im,
    input [15:0] x1_re, x1_im,
    input [15:0] x2_re, x2_im,
    input [15:0] x3_re, x3_im,
    output [15:0] y0_re, y0_im,
    output [15:0] y1_re, y1_im,
    output [15:0] y2_re, y2_im,
    output [15:0] y3_re, y3_im
);

wire signed [16:0] w0_re, w0_im;
wire signed [16:0] w1_re, w1_im;
wire signed [16:0] w2_re, w2_im;
wire signed [16:0] w3_re, w3_im;

// Twiddle factors for 4-point FFT
assign w0_re = 16'h0001;  // cos(0)
assign w0_im = 16'h0000;  // sin(0)
assign w1_re = 16'h0000;  // cos(pi/2)
assign w1_im = 16'hFFFF;  // sin(pi/2)
assign w2_re = 16'hFFFF;  // cos(pi)
assign w2_im = 16'h0000;  // sin(pi)
assign w3_re = 16'h0000;  // cos(3*pi/2)
assign w3_im = 16'h0001;  // sin(3*pi/2)

assign y0_re = x0_re + x1_re + x2_re + x3_re;
assign y0_im = x0_im + x1_im + x2_im + x3_im;

assign y1_re = (x0_re + x1_re) + (x2_re + x3_re * w2_re) + (x3_im * w2_im);
assign y1_im = (x0_im + x1_im) + (x2_im + x3_im * w2_re) - (x3_re * w2_im);

assign y2_re = (x0_re + x2_re) + (x1_re + x3_re * w1_re) - (x3_im * w1_im);
assign y2_im = (x0_im + x2_im) + (x1_im + x3_im * w1_re) + (x3_re * w1_im);

assign y3_re = (x0_re + x3_re) + (x1_re + x2_re * w3_re) - (x2_im * w3_im);
assign y3_im = (x0_im + x3_im) + (x1_im + x2_im * w3_re) + (x2_re * w3_im);

endmodule