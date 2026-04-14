module decade_counter
(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Clear counter to 0000
        end else if (q == 4'b1001) begin
            q <= 4'b0000; // Reset counter after reaching 9
        end else begin
            q <= q + 1; // Increment counter
        end
    end

endmodule