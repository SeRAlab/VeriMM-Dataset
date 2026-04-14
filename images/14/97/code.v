module branch_predictor (
    input clk,
    input reset,
    input branch_out,
    output reg predicted_taken
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state to Strongly Not Taken
        end else begin
            case (state)
                2'b00: begin
                    if (branch_out)
                        state <= 2'b01; // Transition to Weakly Not Taken
                    predicted_taken <= 1'b0; // Predict Not Taken
                end
                2'b01: begin
                    if (branch_out)
                        state <= 2'b10; // Transition to Weakly Taken
                    else
                        state <= 2'b00; // Transition to Strongly Not Taken
                    predicted_taken <= 1'b0; // Predict Not Taken
                end
                2'b10: begin
                    if (branch_out)
                        state <= 2'b11; // Transition to Strongly Taken
                    else
                        state <= 2'b01; // Transition to Weakly Not Taken
                    predicted_taken <= 1'b1; // Predict Taken
                end
                2'b11: begin
                    if (branch_out)
                        state <= 2'b11; // Remain in Strongly Taken
                    else
                        state <= 2'b10; // Transition to Weakly Taken
                    predicted_taken <= 1'b1; // Predict Taken
                end
                default: begin
                    state <= 2'b00; // Default to reset state
                    predicted_taken <= 1'b0; // Default prediction
                end
            endcase
        end
    end
endmodule