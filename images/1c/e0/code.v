module rrt_pathfinder (  
    input clk,  
    input rst,  
    input [7:0] start_x,  
    input [7:0] start_y,  
    input [7:0] goal_x,  
    input [7:0] goal_y,  
    input [7:0] max_iterations,  
    output reg [7:0] path_x,  
    output reg [7:0] path_y,  
    output reg path_found  
);  

    localparam IDLE = 2'b00, FIND_PATH = 2'b01, DONE = 2'b10;  
    reg [1:0] state, next_state;  
    reg [7:0] current_x, current_y;  
    reg [7:0] iteration_count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
            current_x <= start_x;  
            current_y <= start_y;  
            iteration_count <= 0;  
            path_found <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  

    always @(*) begin  
        next_state = state;  
        path_found = 0;  
        case (state)  
            IDLE: begin  
                if (max_iterations > 0)  
                    next_state = FIND_PATH;  
            end  
            FIND_PATH: begin  
                if (iteration_count < max_iterations) begin  
                    // Simulate random movement towards the goal  
                    current_x = (current_x + (goal_x - current_x) / 10);  
                    current_y = (current_y + (goal_y - current_y) / 10);  
                    iteration_count = iteration_count + 1;  
                    if ((current_x == goal_x) && (current_y == goal_y)) begin  
                        path_found = 1;  
                        next_state = DONE;  
                    end  
                end else begin  
                    next_state = DONE;  
                end  
            end  
            DONE: begin  
                path_x = current_x;  
                path_y = current_y;  
                if (path_found) begin  
                    // Path found scenario  
                end else begin  
                    // Path not found scenario  
                end  
            end  
        endcase  
    end  
endmodule