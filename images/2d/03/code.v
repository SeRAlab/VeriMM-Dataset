module slam_position_tracker(  
    input clk,  
    input rst,  
    input [1:0] direction, // 00 = up, 01 = down, 10 = left, 11 = right  
    output reg [2:0] x_pos, // 3 bits for x position (0-4)  
    output reg [2:0] y_pos   // 3 bits for y position (0-4)  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_pos <= 3'b000;  
            y_pos <= 3'b000;  
        end else begin  
            case (direction)  
                2'b00: y_pos <= (y_pos == 3'b000) ? 3'b100 : y_pos - 1; // up  
                2'b01: y_pos <= (y_pos == 3'b100) ? 3'b000 : y_pos + 1; // down  
                2'b10: x_pos <= (x_pos == 3'b000) ? 3'b100 : x_pos - 1; // left  
                2'b11: x_pos <= (x_pos == 3'b100) ? 3'b000 : x_pos + 1; // right  
            endcase  
        end  
    end  
endmodule