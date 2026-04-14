module fft_4point (
    input signed [7:0] x0_real,
    input signed [7:0] x0_imag,
    input signed [7:0] x1_real,
    input signed [7:0] x1_imag,
    input signed [7:0] x2_real,
    input signed [7:0] x2_imag,
    input signed [7:0] x3_real,
    input signed [7:0] x3_imag,
    output reg signed [7:0] y0_real,
    output reg signed [7:0] y0_imag,
    output reg signed [7:0] y1_real,
    output reg signed [7:0] y1_imag,
    output reg signed [7:0] y2_real,
    output reg signed [7:0] y2_imag,
    output reg signed [7:0] y3_real,
    output reg signed [7:0] y3_imag
);
    always @(*) begin
        // FFT calculation for 4-point
        y0_real = x0_real + x1_real + x2_real + x3_real;
        y0_imag = x0_imag + x1_imag + x2_imag + x3_imag;

        // Assuming twiddle factors are pre-calculated and applied accordingly
        y1_real = x0_real + (x1_real >> 1) + (x2_real >> 1) + (x3_real >> 1);
        y1_imag = x0_imag + (x1_imag >> 1) + (x2_imag >> 1) + (x3_imag >> 1);

        y2_real = x0_real - (x1_real >> 1) + (x2_real >> 1) - (x3_real >> 1);
        y2_imag = x0_imag - (x1_imag >> 1) + (x2_imag >> 1) - (x3_imag >> 1);

        y3_real = x0_real - (x1_real >> 1) - (x2_real >> 1) + (x3_real >> 1);
        y3_imag = x0_imag - (x1_imag >> 1) - (x2_imag >> 1) + (x3_imag >> 1);
    end
endmodule