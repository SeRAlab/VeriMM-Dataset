module branch_predictor (
    input clk,
    input reset,
    input branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);

reg [1:0] counter; // 2-bit saturating counter

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 2'b00; // Initialize counter
        prediction <= 1'b0; // Initialize prediction
    end else begin
        // Update prediction based on counter
        if (counter[1]) begin
            prediction <= 1'b1; // Predict taken
        end else begin
            prediction <= 1'b0; // Predict not taken
        end
        
        // Update counter based on outcome
        case (counter)
            2'b00: if (branch_outcome) counter <= 2'b01; else counter <= 2'b00;
            2'b01: if (branch_outcome) counter <= 2'b10; else counter <= 2'b00;
            2'b10: if (branch_outcome) counter <= 2'b11; else counter <= 2'b01;
            2'b11: if (branch_outcome) counter <= 2'b11; else counter <= 2'b10;
        endcase
    end
end

endmodule