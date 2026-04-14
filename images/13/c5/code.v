module a_star_pathfinding(  
    input clk,  
    input reset,  
    input [3:0] current_x,  
    input [3:0] current_y,  
    input [3:0] target_x,  
    input [3:0] target_y,  
    input [15:0] obstacles,  
    output reg [3:0] next_move_x,  
    output reg [3:0] next_move_y  
);  
    // State definitions  
    parameter IDLE = 2'b00,  
              COMPUTE = 2'b01,  
              MOVE = 2'b10;  
              
    reg [1:0] state, next_state;  
    reg [3:0] dx, dy;  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @* begin  
        next_state = state;  
        case (state)  
            IDLE: begin  
                if (current_x != target_x || current_y != target_y)  
                    next_state = COMPUTE;  
            end  
            COMPUTE: begin  
                // Simple heuristic: move towards target  
                if (current_x < target_x) dx = 1;  
                else if (current_x > target_x) dx = -1;  
                else dx = 0;  
                
                if (current_y < target_y) dy = 1;  
                else if (current_y > target_y) dy = -1;  
                else dy = 0;  
                
                next_state = MOVE;  
            end  
            MOVE: begin  
                next_move_x = current_x + dx;  
                next_move_y = current_y + dy;  
                next_state = IDLE;  
            end  
        endcase  
    end  
endmodule