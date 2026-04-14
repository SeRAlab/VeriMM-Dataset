module branch_predictor (
    input clk,
    input reset,
    input [1:0] current_state,
    input outcome,
    output reg [1:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 2'b00; // Reset to Strongly Not Taken
        end else begin
            case (current_state)
                2'b00: next_state <= outcome ? 2'b01 : 2'b00; // Strongly Not Taken
                2'b01: next_state <= outcome ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: next_state <= outcome ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: next_state <= outcome ? 2'b11 : 2'b10; // Strongly Taken
                default: next_state <= 2'b00; // Default to Strongly Not Taken
            endcase
        end
    end
endmodule