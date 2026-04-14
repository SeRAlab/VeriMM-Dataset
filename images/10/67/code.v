module branch_predictor (
    input clk,
    input reset,
    input branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);

    reg [1:0] state; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b10; // Start in Weakly Taken state
            prediction <= 1; // Initial prediction is taken
        end else begin
            case (state)
                2'b00: begin // Strongly Not Taken
                    prediction <= 0;
                    if (branch_outcome) state <= 2'b01; // Move to Weakly Not Taken
                end
                2'b01: begin // Weakly Not Taken
                    prediction <= 0;
                    if (branch_outcome) state <= 2'b10; // Move to Weakly Taken
                    else state <= 2'b00; // Stay Strongly Not Taken
                end
                2'b10: begin // Weakly Taken
                    prediction <= 1;
                    if (branch_outcome) state <= 2'b11; // Move to Strongly Taken
                    else state <= 2'b01; // Move to Weakly Not Taken
                end
                2'b11: begin // Strongly Taken
                    prediction <= 1;
                    if (!branch_outcome) state <= 2'b10; // Move to Weakly Taken
                end
            endcase
        end
    end
endmodule