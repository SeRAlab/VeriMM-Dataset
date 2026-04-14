module branch_predictor(
    input clk,
    input reset,
    input taken, // Actual branch outcome
    input predicted, // Predicted branch outcome
    output reg [1:0] counter, // 2-bit saturating counter
    output reg prediction // Current prediction (Taken or Not Taken)
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Initialize counter to 0
            prediction <= 0; // Initialize prediction to Not Taken
        end else begin
            // Update prediction based on counter value
            if (counter >= 2'b10)
                prediction <= 1; // Taken
            else
                prediction <= 0; // Not Taken
            
            // Update the counter based on actual outcome
            if (taken) begin
                if (counter < 2'b11)
                    counter <= counter + 1; // Increment counter
            end else begin
                if (counter > 2'b00)
                    counter <= counter - 1; // Decrement counter
            end
        end
    end
endmodule