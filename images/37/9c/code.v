module fft_2point (
    input [3:0] a_real,
    input [3:0] a_imag,
    input [3:0] b_real,
    input [3:0] b_imag,
    output reg [3:0] y0_real,
    output reg [3:0] y0_imag,
    output reg [3:0] y1_real,
    output reg [3:0] y1_imag,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y0_real <= 4'b0;
            y0_imag <= 4'b0;
            y1_real <= 4'b0;
            y1_imag <= 4'b0;
        end else begin
            y0_real <= a_real + b_real;
            y0_imag <= a_imag + b_imag;
            y1_real <= a_real - b_real;
            y1_imag <= a_imag - b_imag;
        end
    end
endmodule