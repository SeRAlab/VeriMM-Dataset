module DWT_Haar (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] x,  
    output reg [3:0] a,  
    output reg [3:0] d  
);  

reg [7:0] x_prev;  
reg [7:0] x_curr;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        a <= 4'b0;  
        d <= 4'b0;  
        x_prev <= 8'b0;  
        x_curr <= 8'b0;  
    end else begin  
        x_prev <= x_curr;  
        x_curr <= x;  
        if (x_prev !== 8'b0) begin  
            a <= (x_curr + x_prev) >> 1;  
            d <= (x_curr - x_prev) >> 1;  
        end  
    end  
end  
endmodule