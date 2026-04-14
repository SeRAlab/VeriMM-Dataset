module fft_4_point (
    input signed [7:0] x0_real,
    input signed [7:0] x0_imag,
    input signed [7:0] x1_real,
    input signed [7:0] x1_imag,
    input signed [7:0] x2_real,
    input signed [7:0] x2_imag,
    input signed [7:0] x3_real,
    input signed [7:0] x3_imag,
    output signed [15:0] y0_real,
    output signed [15:0] y0_imag,
    output signed [15:0] y1_real,
    output signed [15:0] y1_imag,
    output signed [15:0] y2_real,
    output signed [15:0] y2_imag,
    output signed [15:0] y3_real,
    output signed [15:0] y3_imag
);
    wire signed [7:0] W0_real = 8'h01;
    wire signed [7:0] W0_imag = 8'h00;
    wire signed [7:0] W1_real = 8'h00;
    wire signed [7:0] W1_imag = -8'h01;
    wire signed [7:0] W2_real = -8'h01;
    wire signed [7:0] W2_imag = 8'h00;
    wire signed [7:0] W3_real = 8'h00;
    wire signed [7:0] W3_imag = 8'h01;

    // FFT calculations
    assign y0_real = x0_real + x1_real + x2_real + x3_real;
    assign y0_imag = x0_imag + x1_imag + x2_imag + x3_imag;

    assign y1_real = (x0_real + x1_real) + W1_real * (x2_real + x3_real);
    assign y1_imag = (x0_imag + x1_imag) + W1_imag * (x2_imag + x3_imag);

    assign y2_real = (x0_real - x1_real) + W2_real * (x2_real - x3_real);
    assign y2_imag = (x0_imag - x1_imag) + W2_imag * (x2_imag - x3_imag);

    assign y3_real = (x0_real + x1_real) - W1_real * (x2_real + x3_real);
    assign y3_imag = (x0_imag + x1_imag) - W1_imag * (x2_imag + x3_imag);
endmodule