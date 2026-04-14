module IIR_Filter (  
    input clk,  
    input rst,  
    input [15:0] x,  
    output reg [15:0] y  
);  
    parameter a = 16'h8000; // Coefficient a = 0.5 in fixed point  
    reg [15:0] y_prev;  
  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 16'b0;  
            y_prev <= 16'b0;  
        end else begin  
            y <= (a * x + (16'hFFFF - a) * y_prev) >> 15; // Fixed point multiplication  
            y_prev <= y;  
        end  
    end  
endmodule