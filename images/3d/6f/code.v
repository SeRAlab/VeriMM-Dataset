module robot_movement(  
    input clk,  
    input rst,  
    input [1:0] direction, // 00=Up, 01=Down, 10=Left, 11=Right  
    output reg [1:0] pos_x,  
    output reg [1:0] pos_y  
);  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            pos_x <= 2'b00;  
            pos_y <= 2'b00;  
        end else begin  
            case (direction)  
                2'b00: if (pos_y < 2'b11) pos_y <= pos_y + 1; // Move Up  
                2'b01: if (pos_y > 2'b00) pos_y <= pos_y - 1; // Move Down  
                2'b10: if (pos_x > 2'b00) pos_x <= pos_x - 1; // Move Left  
                2'b11: if (pos_x < 2'b11) pos_x <= pos_x + 1; // Move Right  
            endcase  
        end  
    end  
endmodule