module fft_4point (
    input [3:0] a_real, a_imag,
    input [3:0] b_real, b_imag,
    input [3:0] c_real, c_imag,
    input [3:0] d_real, d_imag,
    output reg [3:0] out1_real, out1_imag,
    output reg [3:0] out2_real, out2_imag,
    output reg [3:0] out3_real, out3_imag,
    output reg [3:0] out4_real, out4_imag
);

    wire [3:0] w1_real = a_real + b_real;
    wire [3:0] w1_imag = a_imag + b_imag;
    wire [3:0] w2_real = c_real + d_real;
    wire [3:0] w2_imag = c_imag + d_imag;
  
    always @(*) begin
        out1_real = w1_real + w2_real;
        out1_imag = w1_imag + w2_imag;
        out2_real = w1_real - w2_real;
        out2_imag = w1_imag - w2_imag;
        out3_real = a_real - b_real + (c_real - d_real);
        out3_imag = a_imag - b_imag + (c_imag - d_imag);
        out4_real = a_real + b_real - (c_real + d_real);
        out4_imag = a_imag + b_imag - (c_imag + d_imag);
    end
endmodule