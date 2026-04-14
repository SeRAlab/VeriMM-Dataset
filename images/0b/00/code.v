module branch_predictor (
    input clk,
    input reset,
    input branch_taken,
    output reg prediction
);
    reg [1:0] state;

    // State Encoding
    localparam ST_STRONGLY_TAKEN = 2'b11,
               ST_WEAKLY_TAKEN = 2'b10,
               ST_WEAKLY_NOT_TAKEN = 2'b01,
               ST_STRONGLY_NOT_TAKEN = 2'b00;

    // Update state based on branch outcome
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= ST_STRONGLY_NOT_TAKEN; // Reset state
            prediction <= 0; // Default prediction
        end else begin
            case (state)
                ST_STRONGLY_TAKEN: begin
                    if (branch_taken) begin
                        prediction <= 1; // Predict taken
                    end else begin
                        state <= ST_WEAKLY_TAKEN; // Move to weakly taken
                        prediction <= 1; // Predict taken
                    end
                end
                ST_WEAKLY_TAKEN: begin
                    if (branch_taken) begin
                        state <= ST_STRONGLY_TAKEN; // Move to strongly taken
                        prediction <= 1; // Predict taken
                    end else begin
                        state <= ST_WEAKLY_NOT_TAKEN; // Move to weakly not taken
                        prediction <= 1; // Predict taken
                    end
                end
                ST_WEAKLY_NOT_TAKEN: begin
                    if (branch_taken) begin
                        state <= ST_WEAKLY_TAKEN; // Move to weakly taken
                        prediction <= 0; // Predict not taken
                    end else begin
                        state <= ST_STRONGLY_NOT_TAKEN; // Move to strongly not taken
                        prediction <= 0; // Predict not taken
                    end
                end
                ST_STRONGLY_NOT_TAKEN: begin
                    if (branch_taken) begin
                        state <= ST_WEAKLY_NOT_TAKEN; // Move to weakly not taken
                        prediction <= 0; // Predict not taken
                    end else begin
                        prediction <= 0; // Predict not taken
                    end
                end
            endcase
        end
    end
endmodule