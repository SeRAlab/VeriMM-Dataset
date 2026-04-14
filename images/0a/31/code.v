module iir_filter #(parameter A1 = 16'h0001, A2 = 16'h0001, B0 = 16'h0001, B1 = 16'h0001, B2 = 16'h0001) (  
    input clk,  
    input rst,  
    input signed [15:0] x,  
    output reg signed [15:0] y  
);  
    reg signed [15:0] x1, x2;  
    reg signed [15:0] y1, y2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x1 <= 0;  
            x2 <= 0;  
            y1 <= 0;  
            y2 <= 0;  
            y <= 0;  
        end else begin  
            y <= (B0*x) + (B1*x1) + (B2*x2) - (A1*y1) - (A2*y2);  
            x2 <= x1;  
            x1 <= x;  
            y2 <= y1;  
            y1 <= y;  
        end  
    end  
endmodule