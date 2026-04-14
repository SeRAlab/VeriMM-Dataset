module fft_4point (  
    input clk,  
    input rst,  
    input [15:0] a_real,  
    input [15:0] a_imag,  
    input [15:0] b_real,  
    input [15:0] b_imag,  
    input [15:0] c_real,  
    input [15:0] c_imag,  
    input [15:0] d_real,  
    input [15:0] d_imag,  
    output reg [15:0] y0_real,  
    output reg [15:0] y0_imag,  
    output reg [15:0] y1_real,  
    output reg [15:0] y1_imag,  
    output reg [15:0] y2_real,  
    output reg [15:0] y2_imag,  
    output reg [15:0] y3_real,  
    output reg [15:0] y3_imag  
);  
    reg [15:0] stage1_real[0:3], stage1_imag[0:3];  
    reg [15:0] stage2_real[0:3], stage2_imag[0:3];  

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
        end else begin  
            // Stage 1: Input to stage 1 calculations  
            stage1_real[0] <= a_real + b_real;  
            stage1_imag[0] <= a_imag + b_imag;  
            stage1_real[1] <= c_real + d_real;  
            stage1_imag[1] <= c_imag + d_imag;  
            stage1_real[2] <= a_real - b_real;  
            stage1_imag[2] <= a_imag - b_imag;  
            stage1_real[3] <= c_real - d_real;  
            stage1_imag[3] <= c_imag - d_imag;  

            // Stage 2: FFT calculations  
            y0_real <= stage1_real[0] + stage1_real[1];  
            y0_imag <= stage1_imag[0] + stage1_imag[1];  
            y1_real <= stage1_real[2] + stage1_real[3];  
            y1_imag <= stage1_imag[2] + stage1_imag[3];  
            y2_real <= stage1_real[0] - stage1_real[1];  
            y2_imag <= stage1_imag[0] - stage1_imag[1];  
            y3_real <= stage1_real[2] - stage1_real[3];  
            y3_imag <= stage1_imag[2] - stage1_imag[3];  
        end  
    end  
endmodule