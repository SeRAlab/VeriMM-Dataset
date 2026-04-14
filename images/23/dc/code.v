module branch_predictor (
    input clk,
    input reset,
    input branch_outcome,
    output reg prediction
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Start in strongly not taken state
            prediction <= 0;
        end else begin
            prediction <= state[1]; // Output the prediction (11 -> 1, else 0)
            case (state)
                2'b00: if (branch_outcome) state <= 2'b01; // Not Taken -> Weakly Not Taken
                2'b01: if (branch_outcome) state <= 2'b10; // Weakly Not Taken -> Weakly Taken
                        else state <= 2'b00; // Weakly Not Taken -> Strongly Not Taken
                2'b10: if (branch_outcome) state <= 2'b11; // Weakly Taken -> Strongly Taken
                        else state <= 2'b01; // Weakly Taken -> Weakly Not Taken
                2'b11: if (~branch_outcome) state <= 2'b10; // Strongly Taken -> Weakly Taken
            endcase
        end
    end
endmodule