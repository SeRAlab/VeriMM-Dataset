module branch_predictor(
    input wire clk,
    input wire reset,
    input wire branch_outcome, // 0 for not taken, 1 for taken
    output reg prediction // 0 for not taken, 1 for taken
);
    reg [1:0] state; // 2-bit state
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initial state (strongly not taken)
            prediction <= 0;
        end else begin
            case (state)
                2'b00: begin // strongly not taken
                    prediction <= 0;
                    if (branch_outcome) state <= 2'b01; // move to weakly not taken
                end
                2'b01: begin // weakly not taken
                    prediction <= 0;
                    if (branch_outcome) state <= 2'b10; // move to weakly taken
                    else state <= 2'b00; // stay in strongly not taken
                end
                2'b10: begin // weakly taken
                    prediction <= 1;
                    if (branch_outcome) state <= 2'b11; // move to strongly taken
                    else state <= 2'b01; // move to weakly not taken
                end
                2'b11: begin // strongly taken
                    prediction <= 1;
                    if (!branch_outcome) state <= 2'b10; // move to weakly taken
                end
            endcase
        end
    end
endmodule