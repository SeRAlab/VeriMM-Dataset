module branch_predictor (
    input clk,
    input reset,
    input branch_outcome,
    output reg [1:0] prediction
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prediction <= 2'b00; // Initial state
    end else begin
        case (prediction)
            2'b00: prediction <= (branch_outcome) ? 2'b01 : 2'b00; // Strongly not taken
            2'b01: prediction <= (branch_outcome) ? 2'b10 : 2'b00; // Weakly not taken
            2'b10: prediction <= (branch_outcome) ? 2'b11 : 2'b01; // Weakly taken
            2'b11: prediction <= (branch_outcome) ? 2'b11 : 2'b10; // Strongly taken
            default: prediction <= 2'b00; // Default case
        endcase
    end
end

endmodule