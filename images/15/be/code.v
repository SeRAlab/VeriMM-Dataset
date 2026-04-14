module fir_filter (  
    input clk,  
    input rst,  
    input [3:0] x,  // 4-bit input  
    output reg [3:0] y  // 4-bit output  
);  
    reg [3:0] delay_1, delay_2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            delay_1 <= 4'b0000;  
            delay_2 <= 4'b0000;  
            y <= 4'b0000;  
        end else begin  
            delay_2 <= delay_1;  
            delay_1 <= x;  
            y <= (x + (delay_1 << 1) + delay_2);  
        end  
    end  
endmodule