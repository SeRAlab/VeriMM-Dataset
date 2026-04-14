module branch_predictor (
    input clk,
    input reset,
    input actual_outcome, // 0 for not taken, 1 for taken
    output reg predicted_outcome // Prediction output
);
    reg [1:0] history; // 2-bit history

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            history <= 2'b00; // Reset history
            predicted_outcome <= 0; // Default prediction
        end else begin
            // Prediction logic based on history
            case (history)
                2'b00: predicted_outcome <= 0; // Strongly not taken
                2'b01: predicted_outcome <= 0; // Weakly not taken
                2'b10: predicted_outcome <= 1; // Weakly taken
                2'b11: predicted_outcome <= 1; // Strongly taken
            endcase
            
            // Update history based on actual outcome
            if (actual_outcome) begin
                if (history < 2'b11) 
                    history <= history + 1; // Increment history towards "taken"
            end else begin
                if (history > 2'b00) 
                    history <= history - 1; // Decrement history towards "not taken"
            end
        end
    end
endmodule