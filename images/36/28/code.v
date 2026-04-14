module branch_predictor (
    input clk,
    input reset,
    input taken, // Branch taken input
    output reg prediction // Prediction output
);
    reg [1:0] state; // 2-bit state

    // State encoding: 00 (Strongly not taken), 01 (Weakly not taken), 10 (Weakly taken), 11 (Strongly taken)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize state to Strongly not taken
            prediction <= 1'b0; // Prediction output
        end else begin
            case (state)
                2'b00: begin
                    if (taken) begin
                        state <= 2'b01; // Move to Weakly not taken
                    end
                    prediction <= 1'b0; // Predict not taken
                end
                2'b01: begin
                    if (taken) begin
                        state <= 2'b10; // Move to Weakly taken
                    end else begin
                        state <= 2'b00; // Move to Strongly not taken
                    end
                    prediction <= 1'b0; // Predict not taken
                end
                2'b10: begin
                    if (taken) begin
                        state <= 2'b11; // Move to Strongly taken
                    end else begin
                        state <= 2'b01; // Move to Weakly not taken
                    end
                    prediction <= 1'b1; // Predict taken
                end
                2'b11: begin
                    if (taken) begin
                        state <= 2'b11; // Stay in Strongly taken
                    end else begin
                        state <= 2'b10; // Move to Weakly taken
                    end
                    prediction <= 1'b1; // Predict taken
                end
            endcase
        end
    end
endmodule