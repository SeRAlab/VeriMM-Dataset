module branch_predictor (
    input clk,
    input reset,
    input taken, // 1 if the branch was taken, 0 otherwise
    output reg [1:0] counter // 2-bit saturating counter
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 2'b00; // Reset to 0
    end else begin
        if (taken) begin
            if (counter < 2'b11)
                counter <= counter + 1; // Increment
        end else begin
            if (counter > 2'b00)
                counter <= counter - 1; // Decrement
        end
    end
end

endmodule