module IFFT_4point (  
    input clk,  
    input reset,  
    input [15:0] x0,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] x3,  
    output reg [15:0] y0,  
    output reg [15:0] y1,  
    output reg [15:0] y2,  
    output reg [15:0] y3  
);  

    reg [15:0] temp0, temp1, temp2, temp3;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            y0 <= 16'b0;  
            y1 <= 16'b0;  
            y2 <= 16'b0;  
            y3 <= 16'b0;  
        end else begin  
            temp0 = (x0 + x1 + x2 + x3) >> 2;  
            temp1 = ((x0 - x2) + ((x1 - x3) * 8'h00)) >> 2;  
            temp2 = ((x0 - x1) + ((x2 - x3) * 8'h00)) >> 2;  
            temp3 = ((x0 - x3) + ((x1 - x2) * 8'h00)) >> 2;  

            y0 <= temp0;  
            y1 <= temp1;  
            y2 <= temp2;  
            y3 <= temp3;  
        end  
    end  
endmodule