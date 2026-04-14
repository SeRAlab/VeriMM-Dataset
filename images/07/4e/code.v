module fft_4point(  
    input clk,  
    input rst,  
    input [31:0] x0_real,  
    input [31:0] x0_imag,  
    input [31:0] x1_real,  
    input [31:0] x1_imag,  
    input [31:0] x2_real,  
    input [31:0] x2_imag,  
    input [31:0] x3_real,  
    input [31:0] x3_imag,  
    output reg [31:0] y0_real,  
    output reg [31:0] y0_imag,  
    output reg [31:0] y1_real,  
    output reg [31:0] y1_imag,  
    output reg [31:0] y2_real,  
    output reg [31:0] y2_imag,  
    output reg [31:0] y3_real,  
    output reg [31:0] y3_imag  
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
    end else begin  
        // FFT calculations 
        y0_real <= x0_real + x1_real + x2_real + x3_real;  
        y0_imag <= x0_imag + x1_imag + x2_imag + x3_imag;  
        y1_real <= x0_real - x1_real + (x2_real - x3_real);  
        y1_imag <= x0_imag - x1_imag + (x2_imag - x3_imag);  
        y2_real <= x0_real - x2_real;  
        y2_imag <= x0_imag - x2_imag;  
        y3_real <= x1_real - x3_real;  
        y3_imag <= x1_imag - x3_imag;  
    end  
end  
endmodule