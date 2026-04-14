module binary_down_counter
(
    input clk,
    input reset,
    output reg [4:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 5'b11111; // Set counter to 11111
        end else begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule