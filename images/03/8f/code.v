module fft_4point (
    input [15:0] x0_real, x0_imag,
    input [15:0] x1_real, x1_imag,
    input [15:0] x2_real, x2_imag,
    input [15:0] x3_real, x3_imag,
    output reg [15:0] y0_real, y0_imag,
    output reg [15:0] y1_real, y1_imag,
    output reg [15:0] y2_real, y2_imag,
    output reg [15:0] y3_real, y3_imag
);
    wire signed [15:0] w1_real = 16'h0000;  // cos(0*2*pi/4)
    wire signed [15:0] w1_imag = 16'hFFFF;  // sin(0*2*pi/4)
    wire signed [15:0] w2_real = 16'h0000;  // cos(1*2*pi/4)
    wire signed [15:0] w2_imag = 16'hFFFF;  // sin(1*2*pi/4)
    wire signed [15:0] w3_real = 16'h0000;  // cos(2*2*pi/4)
    wire signed [15:0] w3_imag = 16'hFFFF;  // sin(2*2*pi/4)
    
    always @(*) begin
        // Compute FFT
        y0_real = x0_real + x1_real + x2_real + x3_real;
        y0_imag = x0_imag + x1_imag + x2_imag + x3_imag;
        
        y1_real = x0_real + (w1_real * x1_real - w1_imag * x1_imag) + 
                   (w2_real * x2_real - w2_imag * x2_imag) + 
                   (w3_real * x3_real - w3_imag * x3_imag);
        y1_imag = x0_imag + (w1_real * x1_imag + w1_imag * x1_real) + 
                   (w2_real * x2_imag + w2_imag * x2_real) + 
                   (w3_real * x3_imag + w3_imag * x3_real);
        
        y2_real = x0_real + (w1_real * x1_real - w1_imag * x1_imag) - 
                   (w2_real * x2_real - w2_imag * x2_imag) + 
                   (w3_real * x3_real - w3_imag * x3_imag);
        y2_imag = x0_imag + (w1_real * x1_imag + w1_imag * x1_real) - 
                   (w2_real * x2_imag + w2_imag * x2_real) + 
                   (w3_real * x3_imag + w3_imag * x3_real);
        
        y3_real = x0_real + (w1_real * x1_real - w1_imag * x1_imag) - 
                   (w2_real * x2_real - w2_imag * x2_imag) - 
                   (w3_real * x3_real - w3_imag * x3_imag);
        y3_imag = x0_imag + (w1_real * x1_imag + w1_imag * x1_real) - 
                   (w2_real * x2_imag + w2_imag * x2_real) - 
                   (w3_real * x3_imag + w3_imag * x3_real);
    end
endmodule