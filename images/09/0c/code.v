module branch_predictor (
    input clk,
    input reset,
    input branch_outcome, // 1 = taken, 0 = not taken
    output reg prediction // 1 = taken, 0 = not taken
);

    reg [1:0] state; // 2-bit state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize state to '00'
            prediction <= 1'b0; // Initialize prediction to not taken
        end else begin
            case (state)
                2'b00: begin // Strongly not taken
                    prediction <= 1'b0;
                    if (branch_outcome) state <= 2'b01; // Move to weakly not taken
                end
                2'b01: begin // Weakly not taken
                    prediction <= 1'b0;
                    if (branch_outcome) state <= 2'b10; // Move to weakly taken
                    else state <= 2'b00; // Stay in strongly not taken
                end
                2'b10: begin // Weakly taken
                    prediction <= 1'b1;
                    if (branch_outcome) state <= 2'b11; // Move to strongly taken
                    else state <= 2'b01; // Move to weakly not taken
                end
                2'b11: begin // Strongly taken
                    prediction <= 1'b1;
                    if (!branch_outcome) state <= 2'b10; // Move to weakly taken
                end
            endcase
        end
    end
endmodule