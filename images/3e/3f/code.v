module branch_predictor (
    input clk,
    input reset,
    input branch_taken, // signal indicating if the branch was taken
    output reg prediction // prediction output, 1 for taken, 0 for not taken
);
    reg [1:0] state; // 2-bit counter for branch prediction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize state to weakly not taken
            prediction <= 1'b0; // Default prediction is not taken
        end else begin
            prediction <= (state[1] == 1'b1); // Prediction is taken if MSB is 1
            // Update state based on the branch taken signal
            case (state)
                2'b00: state <= branch_taken ? 2'b01 : 2'b00; // weakly not taken
                2'b01: state <= branch_taken ? 2'b10 : 2'b00; // strongly not taken
                2'b10: state <= branch_taken ? 2'b11 : 2'b01; // strongly taken
                2'b11: state <= branch_taken ? 2'b11 : 2'b10; // weakly taken
            endcase
        end
    end
endmodule