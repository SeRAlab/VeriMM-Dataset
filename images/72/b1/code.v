module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [5:0] count
);
    always @(negedge clk) begin
        if (reset) begin
            count <= 6'b000001; // Set counter to 1
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule