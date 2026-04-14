module fft (
    input wire clk,
    input wire rst,
    input wire [15:0] real_in1,
    input wire [15:0] imag_in1,
    input wire [15:0] real_in2,
    input wire [15:0] imag_in2,
    output reg [15:0] real_out1,
    output reg [15:0] imag_out1,
    output reg [15:0] real_out2,
    output reg [15:0] imag_out2
);
    reg [15:0] a_real;
    reg [15:0] a_imag;
    reg [15:0] b_real;
    reg [15:0] b_imag;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            real_out1 <= 0;
            imag_out1 <= 0;
            real_out2 <= 0;
            imag_out2 <= 0;
            a_real <= 0;
            a_imag <= 0;
            b_real <= 0;
            b_imag <= 0;
        end else begin
            a_real <= real_in1;
            a_imag <= imag_in1;
            b_real <= real_in2;
            b_imag <= imag_in2;

            // Simple FFT operation (butterfly operation)
            real_out1 <= a_real + b_real;
            imag_out1 <= a_imag + b_imag;
            real_out2 <= a_real - b_real;
            imag_out2 <= a_imag - b_imag;
        end
    end
endmodule