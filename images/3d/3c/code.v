module branch_predictor (
    input clk,
    input reset,
    input branch_dir, // 0 for not taken, 1 for taken
    output reg prediction // 0 for not taken, 1 for taken
);
    reg [1:0] state; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize to strongly not taken
            prediction <= 0;
        end else begin
            prediction <= state[1]; // Prediction is the MSB of the state
            case (state)
                2'b00: if (branch_dir) state <= 2'b01; // Weakly not taken
                2'b01: if (branch_dir) state <= 2'b10; // Weakly taken
                2'b10: if (branch_dir) state <= 2'b11; // Strongly taken
                        else state <= 2'b01; // Weakly not taken
                2'b11: if (!branch_dir) state <= 2'b10; // Weakly taken
            endcase
        end
    end
endmodule