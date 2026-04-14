module branch_predictor(
    input clk,
    input reset,
    input branch_taken, // 1 if branch is taken, 0 if not
    output reg prediction // 1 if predict taken, 0 if predict not taken
);
    reg [1:0] counter; // 2-bit saturating counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Start with strongly not taken
            prediction <= 0;
        end
        else begin
            prediction <= counter[1]; // Most significant bit is the prediction
            if (branch_taken) begin
                if (counter < 2'b11) begin
                    counter <= counter + 1; // Increment counter
                end
            end
            else begin
                if (counter > 2'b00) begin
                    counter <= counter - 1; // Decrement counter
                end
            end
        end
    end
endmodule