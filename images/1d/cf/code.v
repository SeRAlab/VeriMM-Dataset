module fft_4point (
    input [7:0] x0_real, x0_imag,
    input [7:0] x1_real, x1_imag,
    input [7:0] x2_real, x2_imag,
    input [7:0] x3_real, x3_imag,
    output reg [7:0] y0_real, y0_imag,
    output reg [7:0] y1_real, y1_imag,
    output reg [7:0] y2_real, y2_imag,
    output reg [7:0] y3_real, y3_imag
);
    wire signed [8:0] W0_real, W0_imag;
    wire signed [8:0] W1_real, W1_imag;
    
    // Twiddle factors: W0 = 1, W1 = -j (for FFT)
    assign W0_real = 8'h01; assign W0_imag = 8'h00; // W0 = 1
    assign W1_real = 8'h00; assign W1_imag = -8'h01; // W1 = -j
    
    always @* begin
        // FFT calculations
        y0_real = x0_real + x1_real + x2_real + x3_real;
        y0_imag = x0_imag + x1_imag + x2_imag + x3_imag;
        
        y1_real = x0_real + W1_real*x1_real - W1_imag*x1_imag + 
                   W0_real*x2_real - W0_imag*x2_imag + 
                   W1_real*x3_real - W1_imag*x3_imag;
        y1_imag = x0_imag + W1_real*x1_imag + W1_imag*x1_real + 
                   W0_real*x2_imag + W0_imag*x2_real + 
                   W1_real*x3_imag + W1_imag*x3_real;
        
        y2_real = x0_real - x1_real + x2_real - x3_real;
        y2_imag = x0_imag - x1_imag + x2_imag - x3_imag;
        
        y3_real = x0_real - W1_real*x1_real + W1_imag*x1_imag - 
                   W0_real*x2_real + W0_imag*x2_imag - 
                   W1_real*x3_real + W1_imag*x3_imag;
        y3_imag = x0_imag - W1_real*x1_imag - W1_imag*x1_real - 
                   W0_real*x2_imag - W0_imag*x2_real + 
                   W1_real*x3_imag - W1_imag*x3_real;
    end
endmodule