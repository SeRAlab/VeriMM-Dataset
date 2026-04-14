module slam_robot (  
    input clk,  
    input reset,  
    input move_forward,  
    input rotate_left,  
    input rotate_right,  
    output reg [1:0] direction, // 00: North, 01: East, 10: South, 11: West  
    output reg [3:0] position // position represented as a 4-bit value (x,y)  
);  
    // State encoding  
    localparam NORTH = 2'b00;  
    localparam EAST = 2'b01;  
    localparam SOUTH = 2'b10;  
    localparam WEST = 2'b11;  
    
    // Position variables  
    reg [1:0] x;  
    reg [1:0] y;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            direction <= NORTH;  
            position <= 4'b0000; // Initialize position (0,0)  
            x <= 2'b00;  
            y <= 2'b00;  
        end else begin  
            // Handle rotation  
            if (rotate_left) begin  
                direction <= (direction == NORTH) ? WEST : direction - 1;  
            end else if (rotate_right) begin  
                direction <= (direction == WEST) ? NORTH : direction + 1;  
            end  
            // Handle movement  
            if (move_forward) begin  
                case (direction)  
                    NORTH: y <= y + 1;  
                    EAST: x <= x + 1;  
                    SOUTH: y <= y - 1;  
                    WEST: x <= x - 1;  
                endcase  
            end  
            position <= {x, y}; // Update position output  
        end  
    end  
endmodule