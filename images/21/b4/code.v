module branch_predictor(
    input clk,
    input rst,
    input [1:0] branch_id,
    input actual_outcome,
    output reg predicted_outcome
);
    reg [1:0] state [3:0]; // State for 4 branches (2-bit saturating counter)

    initial begin
        state[0] = 2'b00; // Strongly Not Taken
        state[1] = 2'b01; // Weakly Not Taken
        state[2] = 2'b10; // Weakly Taken
        state[3] = 2'b11; // Strongly Taken
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            predicted_outcome <= 0;
            // Reset states
            state[0] <= 2'b00;
            state[1] <= 2'b01;
            state[2] <= 2'b10;
            state[3] <= 2'b11;
        end else begin
            predicted_outcome <= (state[branch_id] > 1) ? 1 : 0; // Predict taken if state is 2 or 3
            
            // Update state based on actual outcome
            case (state[branch_id])
                2'b00: if (actual_outcome) state[branch_id] <= 2'b01; // Update to Weakly Not Taken
                2'b01: if (actual_outcome) state[branch_id] <= 2'b10; // Update to Weakly Taken
                2'b10: if (!actual_outcome) state[branch_id] <= 2'b01; // Update to Weakly Not Taken
                        else state[branch_id] <= 2'b11; // Update to Strongly Taken
                2'b11: if (!actual_outcome) state[branch_id] <= 2'b10; // Update to Weakly Taken
            endcase
        end
    end
endmodule