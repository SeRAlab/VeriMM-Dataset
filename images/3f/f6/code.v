module fft4 (  
    input clk,  
    input rst,  
    input [15:0] x0_real,  
    input [15:0] x0_imag,  
    input [15:0] x1_real,  
    input [15:0] x1_imag,  
    input [15:0] x2_real,  
    input [15:0] x2_imag,  
    input [15:0] x3_real,  
    input [15:0] x3_imag,  
    output reg [15:0] y0_real,  
    output reg [15:0] y0_imag,  
    output reg [15:0] y1_real,  
    output reg [15:0] y1_imag,  
    output reg [15:0] y2_real,  
    output reg [15:0] y2_imag,  
    output reg [15:0] y3_real,  
    output reg [15:0] y3_imag  
);  
    reg [15:0] temp_real [0:3];  
    reg [15:0] temp_imag [0:3];  
    wire [15:0] w_real [0:3];  
    wire [15:0] w_imag [0:3];  

    // Initialize twiddle factors for FFT  
    assign w_real[0] = 16'h0001;  
    assign w_imag[0] = 16'h0000;  
    assign w_real[1] = 16'h7FFF;  
    assign w_imag[1] = 16'hFFFF;  
    assign w_real[2] = 16'h0000;  
    assign w_imag[2] = 16'hFFFF;  
    assign w_real[3] = 16'h8001;  
    assign w_imag[3] = 16'h0000;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y0_real <= 16'b0;  
            y0_imag <= 16'b0;  
            y1_real <= 16'b0;  
            y1_imag <= 16'b0;  
            y2_real <= 16'b0;  
            y2_imag <= 16'b0;  
            y3_real <= 16'b0;  
            y3_imag <= 16'b0;  
        end else begin  
            // FFT computations  
            temp_real[0] = x0_real + x1_real + x2_real + x3_real;  
            temp_imag[0] = x0_imag + x1_imag + x2_imag + x3_imag;  
            temp_real[1] = (x0_real + x2_real) + ( (x1_real + x3_real) * w_real[1] - (x1_imag + x3_imag) * w_imag[1] );  
            temp_imag[1] = (x0_imag + x2_imag) + ( (x1_real + x3_real) * w_imag[1] + (x1_imag + x3_imag) * w_real[1] );  
            temp_real[2] = (x0_real + x2_real) - ( (x1_real + x3_real) * w_real[1] - (x1_imag + x3_imag) * w_imag[1] );  
            temp_imag[2] = (x0_imag + x2_imag) - ( (x1_real + x3_real) * w_imag[1] + (x1_imag + x3_imag) * w_real[1] );  
            y0_real <= temp_real[0];  
            y0_imag <= temp_imag[0];  
            y1_real <= temp_real[1];  
            y1_imag <= temp_imag[1];  
            y2_real <= temp_real[2];  
            y2_imag <= temp_imag[2];  
            y3_real <= temp_real[3];  
            y3_imag <= temp_imag[3];  
        end  
    end  
endmodule