module branch_predictor (
    input clk,
    input reset,
    input [1:0] current_state,
    input taken,
    output reg [1:0] next_state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            next_state <= 2'b00; // reset to Strongly Not Taken
        end else begin
            case (current_state)
                2'b00: next_state <= taken ? 2'b01 : 2'b00; // Not Taken -> 00, Taken -> 01
                2'b01: next_state <= taken ? 2'b10 : 2'b00; // Not Taken -> 00, Taken -> 10
                2'b10: next_state <= taken ? 2'b11 : 2'b01; // Not Taken -> 01, Taken -> 11
                2'b11: next_state <= taken ? 2'b11 : 2'b10; // Not Taken -> 10, Taken -> 11
                default: next_state <= 2'b00; // default case
            endcase
        end
    end
endmodule