module branch_predictor(
    input clk,
    input rst,
    input outcome, // Current branch outcome (0: not taken, 1: taken)
    output reg prediction // Predicted outcome (0: not taken, 1: taken)
);
    reg [1:0] state; // 2-bit state for the predictor

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // Initialize state to Strongly Not Taken
            prediction <= 1'b0; // Initial prediction is Not Taken
        end else begin
            prediction <= state[1]; // Predict based on the current state
            case (state)
                2'b00: if (outcome) state <= 2'b01; // Strongly Not Taken to Weakly Not Taken
                2'b01: if (outcome) state <= 2'b10; // Weakly Not Taken to Weakly Taken
                        else state <= 2'b00; // Weakly Not Taken to Strongly Not Taken
                2'b10: if (outcome) state <= 2'b11; // Weakly Taken to Strongly Taken
                        else state <= 2'b01; // Weakly Taken to Weakly Not Taken
                2'b11: if (~outcome) state <= 2'b10; // Strongly Taken to Weakly Taken
            endcase
        end
    end
endmodule