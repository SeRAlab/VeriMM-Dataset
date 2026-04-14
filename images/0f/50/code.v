module jk_latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 0 && K == 0) begin
            // Do nothing (Q remains unchanged)
        end else if (J == 1 && K == 0) begin
            Q <= 1; // Set Q
        end else if (J == 0 && K == 1) begin
            Q <= 0; // Reset Q
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle Q
        end
    end
endmodule