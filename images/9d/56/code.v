module up_down_counter
(
    input clk,
    input reset,
    input mode,
    output reg [3:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b0000; // Set counter to 0
        end else begin
            if (mode) begin
                count <= count + 1; // Increment counter
            end else begin
                count <= count - 1; // Decrement counter
            end
        end
    end

endmodule