module branch_predictor (
    input clk,
    input reset,
    input branch_prediction, // 1 for taken, 0 for not taken
    input actual_outcome,    // 1 for taken, 0 for not taken
    output reg prediction     // 1 for taken, 0 for not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Start at Strongly Not Taken
            prediction <= 0;
        end else begin
            prediction <= counter[1]; // Predict based on the MSB of counter
            // Update the counter based on actual outcome
            if (actual_outcome) begin
                if (counter < 2'b11)
                    counter <= counter + 1; // Increment
            end else begin
                if (counter > 2'b00)
                    counter <= counter - 1; // Decrement
            end
        end
    end
endmodule