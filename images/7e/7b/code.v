module down_counter
(
    input clk,
    input reset,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b11111111; // Reset counter to 11111111
        end else begin
            count <= count - 1; // Decrement counter
        end
    end

endmodule