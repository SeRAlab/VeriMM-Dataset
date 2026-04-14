module fft_4point (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire signed [15:0] x0_real,
    input wire signed [15:0] x0_imag,
    input wire signed [15:0] x1_real,
    input wire signed [15:0] x1_imag,
    input wire signed [15:0] x2_real,
    input wire signed [15:0] x2_imag,
    input wire signed [15:0] x3_real,
    input wire signed [15:0] x3_imag,
    output reg signed [15:0] y0_real,
    output reg signed [15:0] y0_imag,
    output reg signed [15:0] y1_real,
    output reg signed [15:0] y1_imag,
    output reg signed [15:0] y2_real,
    output reg signed [15:0] y2_imag,
    output reg signed [15:0] y3_real,
    output reg signed [15:0] y3_imag,
    output reg done
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        y0_real <= 0;
        y0_imag <= 0;
        y1_real <= 0;
        y1_imag <= 0;
        y2_real <= 0;
        y2_imag <= 0;
        y3_real <= 0;
        y3_imag <= 0;
        done <= 0;
    end else if (valid) begin
        // FFT computation for 4-point FFT
        y0_real <= x0_real + x1_real + x2_real + x3_real;
        y0_imag <= x0_imag + x1_imag + x2_imag + x3_imag;
        
        y1_real <= x0_real + (x1_real >> 1) + (x2_real >> 1) - (x3_real >> 1);
        y1_imag <= x0_imag + (x1_imag >> 1) + (x2_imag >> 1) - (x3_imag >> 1);
        
        y2_real <= x0_real - (x1_real >> 1) + (x2_real >> 1) - (x3_real >> 1);
        y2_imag <= x0_imag - (x1_imag >> 1) + (x2_imag >> 1) - (x3_imag >> 1);
        
        y3_real <= x0_real - x1_real + x2_real - x3_real;
        y3_imag <= x0_imag - x1_imag + x2_imag - x3_imag;
        
        done <= 1;
    end
end

endmodule