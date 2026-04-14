module fft_butterfly (  
    input clk,  
    input signed [7:0] a_real,  
    input signed [7:0] a_imag,  
    input signed [7:0] b_real,  
    input signed [7:0] b_imag,  
    output reg signed [7:0] out1_real,  
    output reg signed [7:0] out1_imag,  
    output reg signed [7:0] out2_real,  
    output reg signed [7:0] out2_imag  
);  
    always @(posedge clk) begin  
        out1_real <= a_real + b_real;  
        out1_imag <= a_imag + b_imag;  
        out2_real <= a_real - b_real;  
        out2_imag <= a_imag - b_imag;  
    end  
endmodule