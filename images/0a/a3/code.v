module branch_predictor(
    input clk,
    input reset,
    input actual_outcome, // 1 for taken, 0 for not taken
    output reg [1:0] state // 2-bit state
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Reset to strongly not taken
        end else begin
            case (state)
                2'b00: state <= (actual_outcome) ? 2'b01 : 2'b00; // 00 -> 01 or stays 00
                2'b01: state <= (actual_outcome) ? 2'b10 : 2'b00; // 01 -> 10 or goes to 00
                2'b10: state <= (actual_outcome) ? 2'b11 : 2'b01; // 10 -> 11 or goes to 01
                2'b11: state <= (actual_outcome) ? 2'b11 : 2'b10; // 11 -> stays 11 or goes to 10
                default: state <= 2'b00;
            endcase
        end
    end
endmodule