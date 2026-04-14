module fft_butterfly (
    input clk,
    input rst,
    input signed [15:0] input1_real,
    input signed [15:0] input1_imag,
    input signed [15:0] input2_real,
    input signed [15:0] input2_imag,
    input signed [15:0] twiddle_real,
    input signed [15:0] twiddle_imag,
    output reg signed [15:0] output1_real,
    output reg signed [15:0] output1_imag,
    output reg signed [15:0] output2_real,
    output reg signed [15:0] output2_imag
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output1_real <= 0;
            output1_imag <= 0;
            output2_real <= 0;
            output2_imag <= 0;
        end else begin
            output1_real <= input1_real + twiddle_real * input2_real - twiddle_imag * input2_imag;
            output1_imag <= input1_imag + twiddle_real * input2_imag + twiddle_imag * input2_real;
            output2_real <= input1_real - (twiddle_real * input2_real) + (twiddle_imag * input2_imag);
            output2_imag <= input1_imag - (twiddle_real * input2_imag) - (twiddle_imag * input2_real);
        end
    end
endmodule