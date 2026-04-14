module binary_down_counter_with_enable
(
    input clk,
    input reset,
    input enable,
    output reg [3:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b1111; // Set counter to 1111
        end else if (enable) begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule