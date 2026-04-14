module fft_butterfly #(parameter WIDTH = 8) (  
    input [WIDTH-1:0] a_real,  
    input [WIDTH-1:0] a_imag,  
    input [WIDTH-1:0] b_real,  
    input [WIDTH-1:0] b_imag,  
    input [WIDTH-1:0] w_real,  
    input [WIDTH-1:0] w_imag,  
    output reg [WIDTH-1:0] out1_real,  
    output reg [WIDTH-1:0] out1_imag,  
    output reg [WIDTH-1:0] out2_real,  
    output reg [WIDTH-1:0] out2_imag,  
    input clk,  
    input rst  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out1_real <= 0;  
            out1_imag <= 0;  
            out2_real <= 0;  
            out2_imag <= 0;  
        end else begin  
            out1_real <= a_real + (w_real * b_real - w_imag * b_imag);  
            out1_imag <= a_imag + (w_real * b_imag + w_imag * b_real);  
            out2_real <= a_real - (w_real * b_real - w_imag * b_imag);  
            out2_imag <= a_imag - (w_real * b_imag + w_imag * b_real);  
        end  
    end  
endmodule