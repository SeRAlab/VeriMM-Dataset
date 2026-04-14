module branch_predictor (
    input clk,
    input reset,
    input actual_branch,
    input [1:0] state, // Current state (2-bits)
    output reg predicted_branch,
    output reg [1:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 2'b00; // Reset to strongly not taken
            predicted_branch <= 1'b0; // Predict not taken
        end else begin
            case (state)
                2'b00: begin // Strongly not taken
                    predicted_branch <= 1'b0;
                    next_state <= actual_branch ? 2'b01 : 2'b00; // Transition
                end
                2'b01: begin // Weakly not taken
                    predicted_branch <= 1'b0;
                    next_state <= actual_branch ? 2'b10 : 2'b00; // Transition
                end
                2'b10: begin // Weakly taken
                    predicted_branch <= 1'b1;
                    next_state <= actual_branch ? 2'b11 : 2'b01; // Transition
                end
                2'b11: begin // Strongly taken
                    predicted_branch <= 1'b1;
                    next_state <= actual_branch ? 2'b11 : 2'b10; // Transition
                end
                default: begin
                    predicted_branch <= 1'b0;
                    next_state <= 2'b00; // Default case
                end
            endcase
        end
    end
endmodule