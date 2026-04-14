module branch_predictor (
    input clk,
    input rst,
    input actual_outcome,
    output reg predicted_outcome
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // Initialize to Strongly Not Taken
        end else begin
            case (state)
                2'b00: begin
                    predicted_outcome <= 1'b0; // Predict Not Taken
                    if (actual_outcome)
                        state <= 2'b01; // Move to Weakly Not Taken
                end
                2'b01: begin
                    predicted_outcome <= 1'b0; // Predict Not Taken
                    if (actual_outcome)
                        state <= 2'b10; // Move to Weakly Taken
                    else
                        state <= 2'b00; // Move to Strongly Not Taken
                end
                2'b10: begin
                    predicted_outcome <= 1'b1; // Predict Taken
                    if (actual_outcome)
                        state <= 2'b11; // Move to Strongly Taken
                    else
                        state <= 2'b01; // Move to Weakly Not Taken
                end
                2'b11: begin
                    predicted_outcome <= 1'b1; // Predict Taken
                    if (~actual_outcome)
                        state <= 2'b10; // Move to Weakly Taken
                end
            endcase
        end
    end
endmodule