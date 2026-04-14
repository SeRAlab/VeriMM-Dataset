module up_down_counter
(
    input clk,
    input reset,
    input enable,
    input direction,
    output reg [15:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 16'b0000000000000000; // Set counter to 0
        end else if (enable) begin
            if (direction) begin
                count <= count + 1; // Increment counter
            end else begin
                count <= count - 1; // Decrement counter
            end
        end
    end

endmodule