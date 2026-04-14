module robot_navigation (input clk, input rst, input [1:0] direction, output reg [3:0] position_x, output reg [3:0] position_y);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            position_x <= 4'b0000;  
            position_y <= 4'b0000;  
        end else begin  
            case (direction)  
                2'b00: position_y <= (position_y == 4'b1111) ? 4'b0000 : position_y + 1; // Move Up  
                2'b01: position_y <= (position_y == 4'b0000) ? 4'b1111 : position_y - 1; // Move Down  
                2'b10: position_x <= (position_x == 4'b1111) ? 4'b0000 : position_x + 1; // Move Right  
                2'b11: position_x <= (position_x == 4'b0000) ? 4'b1111 : position_x - 1; // Move Left  
            endcase  
        end  
    end  
endmodule