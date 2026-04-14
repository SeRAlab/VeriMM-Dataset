module ChebyshevFilter #(parameter WIDTH = 16) (  
    input clk,  
    input rst,  
    input signed [WIDTH-1:0] x,  
    output reg signed [WIDTH-1:0] y  
);  
    reg signed [WIDTH-1:0] a1, a2;  
    reg signed [WIDTH-1:0] b0, b1, b2;  
    parameter signed [WIDTH-1:0] G = 32768; // Gain factor (1.0 in Q15 format)  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 0;  
            a1 <= 0;  
            a2 <= 0;  
        end else begin  
            // Chebyshev filter difference equation  
            y <= (G * x + a1 + a2) >>> 15;  
            a2 <= a1;  
            a1 <= y;  
        end  
    end  
endmodule