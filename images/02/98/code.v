module AStarSearch (
    input clk,
    input reset,
    input [3:0] current_state,
    input [3:0] target_state,
    input [15:0] cost_to_adjacent,
    output reg [3:0] next_state
);
    reg [3:0] f_score [0:15]; // f_score array for each state
    reg [3:0] g_score [0:15]; // g_score array for each state
    reg [3:0] h_score [0:15]; // h_score array for each state
    integer i;

    // States
    localparam IDLE = 4'b0000, COMPUTE = 4'b0001, SELECT = 4'b0010;

    reg [3:0] current_fsm_state, next_fsm_state;

    // FSM for state management
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_fsm_state <= IDLE;
        else
            current_fsm_state <= next_fsm_state;
    end

    // Next state logic for FSM
    always @(*) begin
        case (current_fsm_state)
            IDLE: begin
                if (current_state != target_state)
                    next_fsm_state = COMPUTE;
                else
                    next_fsm_state = IDLE;
            end
            COMPUTE: begin
                // Compute g_score, h_score, f_score
                for (i = 0; i < 16; i = i + 1) begin
                    g_score[i] = cost_to_adjacent[i]; // taking cost as g_score for simplicity
                    h_score[i] = 0; // heuristic is zero for this simplified example
                    f_score[i] = g_score[i] + h_score[i];
                end
                next_fsm_state = SELECT;
            end
            SELECT: begin
                // Select the next state with the lowest f_score
                next_state = current_state;
                for (i = 0; i < 16; i = i + 1) begin
                    if (f_score[i] < f_score[next_state])
                        next_state = i;
                end
                next_fsm_state = IDLE; // go back to idle after selection
            end
            default: next_fsm_state = IDLE;
        endcase
    end
endmodule