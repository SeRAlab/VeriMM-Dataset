module binary_counter
(
    input clk,
    input reset,
    input enable,
    output reg [2:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 3'b100; // Set counter to 4
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule