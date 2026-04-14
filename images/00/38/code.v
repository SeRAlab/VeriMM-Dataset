module FFT_4point (
    input [7:0] x0_real, x0_imag,
    input [7:0] x1_real, x1_imag,
    input [7:0] x2_real, x2_imag,
    input [7:0] x3_real, x3_imag,
    output [15:0] y0_real, y0_imag,
    output [15:0] y1_real, y1_imag,
    output [15:0] y2_real, y2_imag,
    output [15:0] y3_real, y3_imag
);
    wire signed [15:0] W0_real = 16'h0001; // W[0] = 1
    wire signed [15:0] W0_imag = 16'h0000; // W[0] = 0
    wire signed [15:0] W1_real = 16'h0000; // W[1] = 0
    wire signed [15:0] W1_imag = 16'hFFFF; // W[1] = -1
    wire signed [15:0] W2_real = 16'hFFFF; // W[2] = -1
    wire signed [15:0] W2_imag = 16'h0000; // W[2] = 0
    wire signed [15:0] W3_real = 16'h0000; // W[3] = 0
    wire signed [15:0] W3_imag = 16'h0001; // W[3] = i

    wire signed [15:0] x0_real_w = {8'b0, x0_real};
    wire signed [15:0] x0_imag_w = {8'b0, x0_imag};
    wire signed [15:0] x1_real_w = {8'b0, x1_real};
    wire signed [15:0] x1_imag_w = {8'b0, x1_imag};
    wire signed [15:0] x2_real_w = {8'b0, x2_real};
    wire signed [15:0] x2_imag_w = {8'b0, x2_imag};
    wire signed [15:0] x3_real_w = {8'b0, x3_real};
    wire signed [15:0] x3_imag_w = {8'b0, x3_imag};

    assign y0_real = x0_real_w + x1_real_w + x2_real_w + x3_real_w;
    assign y0_imag = x0_imag_w + x1_imag_w + x2_imag_w + x3_imag_w;
    
    assign y1_real = x0_real_w + (W1_real * x1_real_w - W1_imag * x1_imag_w) + (W2_real * x2_real_w - W2_imag * x2_imag_w) + (W3_real * x3_real_w - W3_imag * x3_imag_w);
    assign y1_imag = x0_imag_w + (W1_real * x1_imag_w + W1_imag * x1_real_w) + (W2_real * x2_imag_w + W2_imag * x2_real_w) + (W3_real * x3_imag_w + W3_imag * x3_real_w);

    assign y2_real = x0_real_w + (W2_real * x2_real_w - W2_imag * x2_imag_w) + (W1_real * x1_real_w + W1_imag * x1_imag_w) + (W3_real * x3_real_w - W3_imag * x3_imag_w);
    assign y2_imag = x0_imag_w + (W2_real * x2_imag_w + W2_imag * x2_real_w) + (W1_real * x1_imag_w - W1_imag * x1_real_w) + (W3_real * x3_imag_w + W3_imag * x3_real_w);
    
    assign y3_real = x0_real_w + (W3_real * x3_real_w - W3_imag * x3_imag_w) + (W1_real * x1_real_w + W1_imag * x1_imag_w) + (W2_real * x2_real_w - W2_imag * x2_imag_w);
    assign y3_imag = x0_imag_w + (W3_real * x3_imag_w + W3_imag * x3_real_w) + (W1_real * x1_imag_w - W1_imag * x1_real_w) + (W2_real * x2_imag_w + W2_imag * x2_real_w);

endmodule