module RRT (
    input clk,
    input rst,
    input [4:0] start_x,
    input [4:0] start_y,
    input [4:0] goal_x,
    input [4:0] goal_y,
    output reg [4:0] path_x,
    output reg [4:0] path_y,
    output reg done
);

    // Simple state representation
    reg [2:0] state;
    reg [4:0] current_x, current_y;

    // State definitions
    parameter IDLE = 3'b000, GROW_TREE = 3'b001, PATH_FOUND = 3'b010;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            current_x <= start_x;
            current_y <= start_y;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    path_x <= start_x;
                    path_y <= start_y;
                    state <= GROW_TREE;
                end
                GROW_TREE: begin
                    // Randomly move towards the goal (for simplicity, increment towards the goal)
                    if (current_x < goal_x) current_x <= current_x + 1;
                    if (current_y < goal_y) current_y <= current_y + 1;
                    if (current_x == goal_x && current_y == goal_y) begin
                        state <= PATH_FOUND;
                        done <= 1;
                    end
                    path_x <= current_x;
                    path_y <= current_y;
                end
                PATH_FOUND: begin
                    // Remain in this state when path is found
                    path_x <= current_x;
                    path_y <= current_y;
                end
            endcase
        end
    end
endmodule