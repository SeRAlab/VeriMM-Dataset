module branch_predictor (
    input clk,
    input reset,
    input branch_taken,
    output reg prediction
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset state to strongly not taken
            prediction <= 1'b0; // Initial prediction is not taken
        end else begin
            case (state)
                2'b00: begin // strongly not taken
                    if (branch_taken) begin
                        state <= 2'b01; // Move to weakly not taken
                    end
                    prediction <= 1'b0; // Prediction is not taken
                end
                2'b01: begin // weakly not taken
                    if (branch_taken) begin
                        state <= 2'b10; // Move to weakly taken
                    end
                    prediction <= 1'b0; // Prediction is not taken
                end
                2'b10: begin // weakly taken
                    if (branch_taken) begin
                        state <= 2'b11; // Move to strongly taken
                    end else begin
                        state <= 2'b01; // Move back to weakly not taken
                    end
                    prediction <= 1'b1; // Prediction is taken
                end
                2'b11: begin // strongly taken
                    if (~branch_taken) begin
                        state <= 2'b10; // Move to weakly taken
                    end
                    prediction <= 1'b1; // Prediction is taken
                end
            endcase
        end
    end
endmodule