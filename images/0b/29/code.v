module fir_filter(clk, rst, x, y);  
    input clk;  
    input rst;  
    input [3:0] x;  
    output reg [3:0] y;  

    reg [3:0] x_reg [0:3]; // 4-tap registers  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_reg[0] <= 0;  
            x_reg[1] <= 0;  
            x_reg[2] <= 0;  
            x_reg[3] <= 0;  
            y <= 0;  
        end else begin  
            // Shift registers  
            x_reg[3] <= x_reg[2];  
            x_reg[2] <= x_reg[1];  
            x_reg[1] <= x_reg[0];  
            x_reg[0] <= x;  
            
            // Compute output  
            y <= (1*x_reg[0] + 2*x_reg[1] + 3*x_reg[2] + 4*x_reg[3]);  
        end  
    end  
endmodule