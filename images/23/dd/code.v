module SLAM (  
    input clk,  
    input rst,  
    input move_up,  
    input move_down,  
    input move_left,  
    input move_right,  
    input map_update,  
    output reg [7:0] position_x,  
    output reg [7:0] position_y,  
    output reg [1:0] map_status  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            position_x <= 8'd0;  
            position_y <= 8'd0;  
            map_status <= 2'b00;  
        end else begin  
            if (move_up) position_y <= position_y + 1;  
            if (move_down) position_y <= position_y - 1;  
            if (move_left) position_x <= position_x - 1;  
            if (move_right) position_x <= position_x + 1;  
            if (map_update) map_status <= 2'b01; // Update mapping status  
        end  
    end  
endmodule