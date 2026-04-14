module branch_predictor(
    input clk,
    input reset,
    input branch_outcome, // 1 for taken, 0 for not taken
    output reg prediction // 1 for taken, 0 for not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // reset counter
            prediction <= 1'b0; // initial prediction not taken
        end else begin
            prediction <= counter[1]; // most significant bit of counter is the prediction
            if (branch_outcome) begin
                if (counter < 2'b11) begin
                    counter <= counter + 1; // increment counter
                end
            end else begin
                if (counter > 2'b00) begin
                    counter <= counter - 1; // decrement counter
                end
            end
        end
    end
endmodule