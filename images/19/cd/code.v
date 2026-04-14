module AStar(
    input clk,
    input rst,
    input [3:0] current_state_x,
    input [3:0] current_state_y,
    input [3:0] goal_state_x,
    input [3:0] goal_state_y,
    input [7:0] cost_to_goal,
    output reg [3:0] next_state_x,
    output reg [3:0] next_state_y,
    output reg [7:0] path_cost
);
    reg [7:0] heuristic;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_state_x <= 0;
            next_state_y <= 0;
            path_cost <= 0;
        end else begin
            // Calculate Manhattan distance heuristic
            heuristic <= (current_state_x > goal_state_x ? current_state_x - goal_state_x : goal_state_x - current_state_x) +
                          (current_state_y > goal_state_y ? current_state_y - goal_state_y : goal_state_y - current_state_y);
            path_cost <= cost_to_goal + heuristic;

            // Determine next state based on the heuristic
            if (heuristic < cost_to_goal) begin
                next_state_x <= current_state_x + (current_state_x < goal_state_x ? 1 : (current_state_x > goal_state_x ? -1 : 0));
                next_state_y <= current_state_y + (current_state_y < goal_state_y ? 1 : (current_state_y > goal_state_y ? -1 : 0));
            end else begin
                next_state_x <= current_state_x;
                next_state_y <= current_state_y;
            end
        end
    end
endmodule