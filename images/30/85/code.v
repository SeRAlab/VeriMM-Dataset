module fft_4_point (
    input signed [15:0] x0_real, input signed [15:0] x0_imag,
    input signed [15:0] x1_real, input signed [15:0] x1_imag,
    input signed [15:0] x2_real, input signed [15:0] x2_imag,
    input signed [15:0] x3_real, input signed [15:0] x3_imag,
    output signed [15:0] y0_real, output signed [15:0] y0_imag,
    output signed [15:0] y1_real, output signed [15:0] y1_imag,
    output signed [15:0] y2_real, output signed [15:0] y2_imag,
    output signed [15:0] y3_real, output signed [15:0] y3_imag
);
    wire signed [15:0] temp0_real, temp0_imag, temp1_real, temp1_imag;
    wire signed [15:0] temp2_real, temp2_imag, temp3_real, temp3_imag;
    
    // Stage 1
    assign temp0_real = x0_real + x2_real;
    assign temp0_imag = x0_imag + x2_imag;
    assign temp1_real = x1_real + x3_real;
    assign temp1_imag = x1_imag + x3_imag;
    
    assign temp2_real = x0_real - x2_real;
    assign temp2_imag = x0_imag - x2_imag;
    assign temp3_real = (x1_real - x3_real) * 16'h0000 + (x1_imag - x3_imag) * 16'h0001;
    assign temp3_imag = (x1_imag - x3_imag) * 16'h0000 - (x1_real - x3_real) * 16'h0001;
    
    // Stage 2
    assign y0_real = temp0_real + temp1_real;
    assign y0_imag = temp0_imag + temp1_imag;
    assign y1_real = temp0_real - temp1_real;
    assign y1_imag = temp0_imag - temp1_imag;
    assign y2_real = temp2_real + temp3_real;
    assign y2_imag = temp2_imag + temp3_imag;
    assign y3_real = temp2_real - temp3_real;
    assign y3_imag = temp2_imag - temp3_imag;

endmodule