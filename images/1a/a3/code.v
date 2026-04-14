module RRT_Controller (  
    input clk,  
    input reset,  
    input [7:0] x,  
    input [7:0] y,  
    input [7:0] tx,  
    input [7:0] ty,  
    input explore,  
    output reg [7:0] new_x,  
    output reg [7:0] new_y  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_x <= 8'b0;  
            new_y <= 8'b0;  
        end else if (explore) begin  
            new_x <= (x + tx) >> 1; // Move towards target x  
            new_y <= (y + ty) >> 1; // Move towards target y  
        end  
    end  
endmodule