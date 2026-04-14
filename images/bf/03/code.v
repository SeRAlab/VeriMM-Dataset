module up_down_counter
(
    input clk,
    input reset,
    input up_down,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000; // Clear counter to 00000000
        end else begin
            if (up_down) begin
                q <= q + 1; // Increment counter
            end else begin
                q <= q - 1; // Decrement counter
            end
        end
    end

endmodule