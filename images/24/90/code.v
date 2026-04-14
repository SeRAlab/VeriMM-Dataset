module branch_predictor (
    input clk,
    input reset,
    input branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] state; // 00: Strongly Not Taken, 01: Weakly Not Taken, 10: Weakly Taken, 11: Strongly Taken

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Start in Strongly Not Taken state
            prediction <= 0;
        end else begin
            case (state)
                2'b00: begin // Strongly Not Taken
                    if (branch_outcome) begin
                        state <= 2'b01; // Move to Weakly Not Taken
                        prediction <= 0; // Predict Not Taken
                    end else begin
                        prediction <= 0; // Predict Not Taken
                    end
                end
                2'b01: begin // Weakly Not Taken
                    if (branch_outcome) begin
                        state <= 2'b10; // Move to Weakly Taken
                        prediction <= 0; // Predict Not Taken
                    end else begin
                        state <= 2'b00; // Move to Strongly Not Taken
                        prediction <= 0; // Predict Not Taken
                    end
                end
                2'b10: begin // Weakly Taken
                    if (branch_outcome) begin
                        state <= 2'b11; // Move to Strongly Taken
                        prediction <= 1; // Predict Taken
                    end else begin
                        state <= 2'b01; // Move to Weakly Not Taken
                        prediction <= 1; // Predict Taken
                    end
                end
                2'b11: begin // Strongly Taken
                    if (branch_outcome) begin
                        prediction <= 1; // Predict Taken
                    end else begin
                        state <= 2'b10; // Move to Weakly Taken
                        prediction <= 1; // Predict Taken
                    end
                end
            endcase
        end
    end
endmodule