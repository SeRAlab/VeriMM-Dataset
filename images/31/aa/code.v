module fft_4_point (
    input [7:0] x0_real, x0_imag,
    input [7:0] x1_real, x1_imag,
    input [7:0] x2_real, x2_imag,
    input [7:0] x3_real, x3_imag,
    output [7:0] y0_real, y0_imag,
    output [7:0] y1_real, y1_imag,
    output [7:0] y2_real, y2_imag,
    output [7:0] y3_real, y3_imag
);
    // FFT calculation implementation
    wire signed [8:0] x0_real_ext = {1'b0, x0_real};
    wire signed [8:0] x0_imag_ext = {1'b0, x0_imag};
    wire signed [8:0] x1_real_ext = {1'b0, x1_real};
    wire signed [8:0] x1_imag_ext = {1'b0, x1_imag};
    wire signed [8:0] x2_real_ext = {1'b0, x2_real};
    wire signed [8:0] x2_imag_ext = {1'b0, x2_imag};
    wire signed [8:0] x3_real_ext = {1'b0, x3_real};
    wire signed [8:0] x3_imag_ext = {1'b0, x3_imag};

    // Calculate FFT outputs
    assign y0_real = (x0_real_ext + x1_real_ext + x2_real_ext + x3_real_ext) >> 2;
    assign y0_imag = (x0_imag_ext + x1_imag_ext + x2_imag_ext + x3_imag_ext) >> 2;

    assign y1_real = (x0_real_ext + x1_real_ext + (x2_real_ext << 1) - (x3_real_ext << 1)) >> 2;
    assign y1_imag = (x0_imag_ext + x1_imag_ext + (x2_imag_ext << 1) - (x3_imag_ext << 1)) >> 2;

    assign y2_real = (x0_real_ext + x1_real_ext - x2_real_ext - x3_real_ext) >> 2;
    assign y2_imag = (x0_imag_ext + x1_imag_ext - x2_imag_ext - x3_imag_ext) >> 2;

    assign y3_real = (x0_real_ext + x1_real_ext - (x2_real_ext << 1) + (x3_real_ext << 1)) >> 2;
    assign y3_imag = (x0_imag_ext + x1_imag_ext - (x2_imag_ext << 1) + (x3_imag_ext << 1)) >> 2;
endmodule