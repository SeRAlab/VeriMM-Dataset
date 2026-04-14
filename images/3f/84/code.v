module RRT(
    input clk,
    input rst,
    input [7:0] start_x,
    input [7:0] start_y,
    input [7:0] goal_x,
    input [7:0] goal_y,
    input [7:0] rand_x,
    input [7:0] rand_y,
    output reg found,
    output reg [7:0] path_x,
    output reg [7:0] path_y
);
    reg [1:0] state, next_state;
    parameter IDLE = 2'b00, CHECK_START = 2'b01, CHECK_GOAL = 2'b10, DONE = 2'b11;

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        found = 0;
        case(state)
            IDLE: begin
                if (!rst)
                    next_state = CHECK_START;
            end
            CHECK_START: begin
                if ((rand_x - start_x) + (rand_y - start_y) <= 8) begin
                    path_x = rand_x;
                    path_y = rand_y;
                    next_state = CHECK_GOAL;
                end
            end
            CHECK_GOAL: begin
                if ((rand_x - goal_x) + (rand_y - goal_y) <= 8) begin
                    found = 1;
                    next_state = DONE;
                end else begin
                    next_state = DONE;
                end
            end
            DONE: begin
                // Finished checking
                next_state = IDLE; // Reset to IDLE
            end
        endcase
    end
endmodule