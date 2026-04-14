module branch_predictor(
    input clk,
    input reset,
    input actual_outcome,  // Actual outcome of the branch
    output reg prediction_correct // Output to indicate if the prediction was correct
);
    reg [1:0] state; // 2-bit counter state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initial state
            prediction_correct <= 0;
        end else begin
            case (state)
                2'b00: begin // Strongly Not Taken
                    prediction_correct <= (actual_outcome == 0);
                    state <= (actual_outcome == 1) ? 2'b01 : 2'b00;
                end
                2'b01: begin // Weakly Not Taken
                    prediction_correct <= (actual_outcome == 0);
                    state <= (actual_outcome == 1) ? 2'b10 : 2'b00;
                end
                2'b10: begin // Weakly Taken
                    prediction_correct <= (actual_outcome == 1);
                    state <= (actual_outcome == 0) ? 2'b01 : 2'b11;
                end
                2'b11: begin // Strongly Taken
                    prediction_correct <= (actual_outcome == 1);
                    state <= (actual_outcome == 0) ? 2'b10 : 2'b11;
                end
            endcase
        end
    end
endmodule