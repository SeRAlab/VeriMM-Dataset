module jk_latch (
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Q_bar
);
    always @(posedge clk) begin
        if (J && !K) begin
            Q <= 1'b1; // Set
        end else if (!J && K) begin
            Q <= 1'b0; // Reset
        end else if (J && K) begin
            Q <= ~Q; // Toggle
        end // If J = 0 and K = 0, Q remains unchanged
        Q_bar <= ~Q; // Update Q_bar
    end
endmodule