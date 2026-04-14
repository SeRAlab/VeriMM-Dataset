module fft_4point (
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
    // FFT computation
    wire signed [15:0] w0_real = 16'h0001; // W_0
    wire signed [15:0] w0_imag = 16'h0000; // W_0
    wire signed [15:0] w1_real = 16'h0000; // W_1
    wire signed [15:0] w1_imag = 16'hFFFF; // W_1
    wire signed [15:0] w2_real = 16'hFFFF; // W_2
    wire signed [15:0] w2_imag = 16'h0000; // W_2
    wire signed [15:0] w3_real = 16'h0000; // W_3
    wire signed [15:0] w3_imag = 16'hFFFF; // W_3

    // Butterfly operations
    wire signed [15:0] temp0_real = x0_real + x2_real;
    wire signed [15:0] temp0_imag = x0_imag + x2_imag;
    wire signed [15:0] temp1_real = x1_real + (w1_real * x3_real - w1_imag * x3_imag);
    wire signed [15:0] temp1_imag = x1_imag + (w1_real * x3_imag + w1_imag * x3_real);

    assign y0_real = temp0_real;
    assign y0_imag = temp0_imag;
    assign y1_real = temp1_real;
    assign y1_imag = temp1_imag;
    assign y2_real = temp0_real - (x2_real);
    assign y2_imag = temp0_imag - (x2_imag);
    assign y3_real = x1_real - (w1_real * x3_real - w1_imag * x3_imag);
    assign y3_imag = x1_imag - (w1_real * x3_imag + w1_imag * x3_real);

endmodule