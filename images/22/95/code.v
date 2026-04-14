module branch_predictor(
    input clk,
    input reset,
    input branch_outcome, // 0 for not taken, 1 for taken
    output reg prediction // 0 for not taken, 1 for taken
);
    reg [1:0] state; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00; // Initialize to Strongly Not Taken
        end else begin
            // Update prediction output based on the state
            prediction <= state[1]; // 1 for taken, 0 for not taken
            
            // Update the state based on the branch outcome
            case (state)
                2'b00: state <= (branch_outcome) ? 2'b01 : 2'b00;
                2'b01: state <= (branch_outcome) ? 2'b10 : 2'b00;
                2'b10: state <= (branch_outcome) ? 2'b11 : 2'b01;
                2'b11: state <= (branch_outcome) ? 2'b11 : 2'b10;
            endcase
        end
    end
endmodule