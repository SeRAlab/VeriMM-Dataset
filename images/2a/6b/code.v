module branch_predictor (
    input wire clk,
    input wire branch_outcome,  // 0 for not taken, 1 for taken
    output reg predicted_outcome // 0 for not taken, 1 for taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk) begin
        // Update the counter based on branch outcome
        case (counter)
            2'b00: begin
                if (branch_outcome) counter <= 2'b01; // Move to Weakly Not Taken
                predicted_outcome <= 0; // Predict Not Taken
            end
            2'b01: begin
                if (branch_outcome) counter <= 2'b10; // Move to Weakly Taken
                predicted_outcome <= 0; // Predict Not Taken
            end
            2'b10: begin
                if (branch_outcome) counter <= 2'b11; // Move to Strongly Taken
                else counter <= 2'b01; // Move to Weakly Not Taken
                predicted_outcome <= 1; // Predict Taken
            end
            2'b11: begin
                if (~branch_outcome) counter <= 2'b10; // Move to Weakly Taken
                predicted_outcome <= 1; // Predict Taken
            end
        endcase
    end
endmodule