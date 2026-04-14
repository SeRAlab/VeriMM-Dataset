module branch_predictor (
    input clk,
    input reset,
    input taken, // 1 if the branch was taken, 0 if not taken
    output reg [1:0] state // Current state of the saturating counter
);
    // State encoding
    parameter STRONGLY_TAKEN = 2'b11;
    parameter WEAKLY_TAKEN = 2'b10;
    parameter WEAKLY_NOT_TAKEN = 2'b01;
    parameter STRONGLY_NOT_TAKEN = 2'b00;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STRONGLY_NOT_TAKEN; // Reset to strongly not taken
        end else begin
            case (state)
                STRONGLY_TAKEN: if (!taken) state <= WEAKLY_TAKEN;
                WEAKLY_TAKEN: if (taken) state <= STRONGLY_TAKEN; else state <= WEAKLY_NOT_TAKEN;
                WEAKLY_NOT_TAKEN: if (taken) state <= WEAKLY_TAKEN; else state <= STRONGLY_NOT_TAKEN;
                STRONGLY_NOT_TAKEN: if (taken) state <= WEAKLY_NOT_TAKEN;
            endcase
        end
    end
endmodule