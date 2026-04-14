module fft_4point (
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
    wire [7:0] sum0_real, sum0_imag, sum1_real, sum1_imag;
    wire [7:0] sum2_real, sum2_imag, sum3_real, sum3_imag;

    // FFT calculations
    assign sum0_real = x0_real + x1_real + x2_real + x3_real;
    assign sum0_imag = x0_imag + x1_imag + x2_imag + x3_imag;

    assign sum1_real = x0_real - x1_real + (x2_real - x3_real);
    assign sum1_imag = x0_imag - x1_imag + (x2_imag - x3_imag);

    assign sum2_real = x0_real + x1_real - x2_real - x3_real;
    assign sum2_imag = x0_imag + x1_imag - x2_imag - x3_imag;

    assign sum3_real = x0_real - x1_real - (x2_real - x3_real);
    assign sum3_imag = x0_imag - x1_imag - (x2_imag - x3_imag);

    assign y0_real = sum0_real;
    assign y0_imag = sum0_imag;
    assign y1_real = sum1_real;
    assign y1_imag = sum1_imag;
    assign y2_real = sum2_real;
    assign y2_imag = sum2_imag;
    assign y3_real = sum3_real;
    assign y3_imag = sum3_imag;

endmodule