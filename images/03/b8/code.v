module branch_predictor (
    input wire clk,
    input wire reset,
    input wire branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize to strongly not taken
            prediction <= 0;
        end else begin
            // Prediction output
            prediction <= state[1]; // Output the most significant bit

            // State transition logic
            case (state)
                2'b00: state <= branch_outcome ? 2'b01 : 2'b00; // Strongly Not Taken
                2'b01: state <= branch_outcome ? 2'b10 : 2'b00; // Weakly Not Taken
                2'b10: state <= branch_outcome ? 2'b11 : 2'b01; // Weakly Taken
                2'b11: state <= branch_outcome ? 2'b11 : 2'b10; // Strongly Taken
                default: state <= 2'b00; // Fallback
            endcase
        end
    end
endmodule