module branch_predictor(
    input clk,
    input reset,
    input branch_dir, // 0: not taken, 1: taken
    output reg prediction // 0: not taken, 1: taken
);
    reg [1:0] state; // 2-bit state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // reset to strongly not taken
            prediction <= 1'b0; // initial prediction is not taken
        end else begin
            // Prediction output based on current state
            prediction <= state[1]; // Most significant bit determines prediction

            // Update state based on branch direction
            case (state)
                2'b00: state <= (branch_dir) ? 2'b01 : 2'b00; // Strongly not taken
                2'b01: state <= (branch_dir) ? 2'b10 : 2'b00; // Weakly not taken
                2'b10: state <= (branch_dir) ? 2'b11 : 2'b01; // Weakly taken
                2'b11: state <= (branch_dir) ? 2'b11 : 2'b10; // Strongly taken
                default: state <= 2'b00; // Default case
            endcase
        end
    end
endmodule