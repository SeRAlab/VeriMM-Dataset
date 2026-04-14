module fir_filter(  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    input [15:0] x4,  
    output reg [31:0] y  
);  
    // Define FIR filter coefficients  
    parameter [15:0] b0 = 16'h0001;  
    parameter [15:0] b1 = 16'h0002;  
    parameter [15:0] b2 = 16'h0003;  
    parameter [15:0] b3 = 16'h0004;  
    parameter [15:0] b4 = 16'h0005;  
   
    always @(*) begin  
        y = (b0 * x0) + (b1 * x1) + (b2 * x2) + (b3 * x3) + (b4 * x4);  
    end  
endmodule