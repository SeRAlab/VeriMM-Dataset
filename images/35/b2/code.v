module rrt_state_machine(
    input clk,
    input reset,
    input start_explore,
    input goal_reached,
    output reg [1:0] current_state
);
    // State definitions
    parameter IDLE = 2'b00;
    parameter EXPLORE = 2'b01;
    parameter GOAL = 2'b10;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start_explore)
                        current_state <= EXPLORE;
                end
                EXPLORE: begin
                    if (goal_reached)
                        current_state <= GOAL;
                end
                GOAL: begin
                    if (reset)
                        current_state <= IDLE; // Go back to IDLE on reset
                end
            endcase
        end
    end
endmodule