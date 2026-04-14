module IIR_Filter #(parameter WIDTH = 16) (  
    input clk,  
    input rst,  
    input signed [WIDTH-1:0] x,  
    input signed [WIDTH-1:0] b0,  
    input signed [WIDTH-1:0] b1,  
    input signed [WIDTH-1:0] b2,  
    input signed [WIDTH-1:0] a1,  
    input signed [WIDTH-1:0] a2,  
    output reg signed [WIDTH-1:0] y  
);  
    reg signed [WIDTH-1:0] x_1, x_2;  
    reg signed [WIDTH-1:0] y_1, y_2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            y <= 0;  
            x_1 <= 0;  
            x_2 <= 0;  
            y_1 <= 0;  
            y_2 <= 0;  
        end else begin  
            y <= (b0 * x) + (b1 * x_1) + (b2 * x_2) - (a1 * y_1) - (a2 * y_2);  
            x_2 <= x_1;  
            x_1 <= x;  
            y_2 <= y_1;  
            y_1 <= y;  
        end  
    end  
endmodule