module branch_predictor (
    input clk,
    input reset,
    input branch_outcome, // 1 for taken, 0 for not taken
    output reg [1:0] prediction_state // 2-bit prediction state
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prediction_state <= 2'b00; // Start in Strongly Not Taken
        end else begin
            case (prediction_state)
                2'b00: prediction_state <= branch_outcome ? 2'b01 : 2'b00; // Strongly Not Taken
                2'b01: prediction_state <= branch_outcome ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: prediction_state <= branch_outcome ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: prediction_state <= branch_outcome ? 2'b11 : 2'b10; // Strongly Taken
                default: prediction_state <= 2'b00; // Default case
            endcase
        end
    end
endmodule