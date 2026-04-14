module branch_predictor (
    input clk,
    input reset,
    input [1:0] current_state, // 2-bit current state
    input branch_outcome, // 1-bit branch outcome (0 for not taken, 1 for taken)
    output reg [1:0] next_state // 2-bit next state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 2'b00; // Reset to strongly not taken
        end else begin
            case (current_state)
                2'b00: next_state <= branch_outcome ? 2'b01 : 2'b00;
                2'b01: next_state <= branch_outcome ? 2'b10 : 2'b00;
                2'b10: next_state <= branch_outcome ? 2'b11 : 2'b01;
                2'b11: next_state <= branch_outcome ? 2'b11 : 2'b10;
                default: next_state <= 2'b00;
            endcase
        end
    end
endmodule