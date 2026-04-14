module fft_4_point (
    input [15:0] x0_real,
    input [15:0] x0_imag,
    input [15:0] x1_real,
    input [15:0] x1_imag,
    input [15:0] x2_real,
    input [15:0] x2_imag,
    input [15:0] x3_real,
    input [15:0] x3_imag,
    output [15:0] y0_real,
    output [15:0] y0_imag,
    output [15:0] y1_real,
    output [15:0] y1_imag,
    output [15:0] y2_real,
    output [15:0] y2_imag,
    output [15:0] y3_real,
    output [15:0] y3_imag
);

    wire [15:0] w0_real, w0_imag, w1_real, w1_imag;
    
    assign w0_real = x0_real + x1_real;
    assign w0_imag = x0_imag + x1_imag;
    assign w1_real = (x0_real - x1_real) + 0; // W_1 = 1
    assign w1_imag = (x0_imag - x1_imag) + 0; // W_1 = 1

    assign y0_real = w0_real + x2_real + x3_real;
    assign y0_imag = w0_imag + x2_imag + x3_imag;
    assign y1_real = w0_real - x2_real - x3_real;
    assign y1_imag = w0_imag - x2_imag - x3_imag;
    assign y2_real = w1_real + (0 - x2_imag) + (0 + x3_imag);
    assign y2_imag = w1_imag + x2_real + x3_real;
    assign y3_real = w1_real - (0 - x2_imag) - (0 + x3_imag);
    assign y3_imag = w1_imag - x2_real - x3_real;

endmodule