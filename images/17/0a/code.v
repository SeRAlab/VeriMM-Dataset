module fir_filter (  
    input [2:0] x,  
    input clk,  
    input rst,  
    output reg [2:0] y  
);  
    reg [2:0] x1, x2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x1 <= 3'b000;  
            x2 <= 3'b000;  
            y <= 3'b000;  
        end else begin  
            y <= x + x1 + x2;  
            x2 <= x1;  
            x1 <= x;  
        end  
    end  
endmodule