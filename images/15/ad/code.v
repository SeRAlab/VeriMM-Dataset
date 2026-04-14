module rrt_tree #(parameter THRESHOLD = 10) (  
    input wire clk,  
    input wire reset,  
    input wire valid,  
    input wire [9:0] new_x,  
    input wire [9:0] new_y,  
    output reg success  
);  
    reg [9:0] last_x, last_y;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            last_x <= 10'b0;  
            last_y <= 10'b0;  
            success <= 0;  
        end else if (valid) begin  
            // Calculate distance squared to avoid sqrt  
            if (((new_x - last_x)**2 + (new_y - last_y)**2) <= (THRESHOLD**2)) begin  
                last_x <= new_x;  
                last_y <= new_y;  
                success <= 1;  
            end else begin  
                success <= 0;  
            end  
        end  
    end  
endmodule