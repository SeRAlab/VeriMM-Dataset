module branch_predictor (
    input wire clk,
    input wire reset,
    input wire branch, // 1 if branch taken, 0 if not taken
    output reg prediction // 1 if predicted taken, 0 if not taken
);

    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Initialize counter to 00
            prediction <= 0;
        end else begin
            // Update prediction based on counter state
            prediction <= (counter[1] == 1) ? 1 : 0;

            // Update counter based on actual branch outcome
            if (branch) begin
                if (counter < 2'b11) counter <= counter + 1; // Increment if not max
            end else begin
                if (counter > 2'b00) counter <= counter - 1; // Decrement if not min
            end
        end
    end
endmodule