module pose_estimation(  
    input clk,  
    input rst,  
    input [7:0] dx,  
    input [7:0] dy,  
    input move_cmd,  
    output reg [15:0] x,  
    output reg [15:0] y,  
    output reg [31:0] movement_count  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x <= 0;  
            y <= 0;  
            movement_count <= 0;  
        end else if (move_cmd) begin  
            x <= x + dx;  
            y <= y + dy;  
            movement_count <= movement_count + 1;  
        end  
    end  
endmodule