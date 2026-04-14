module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 1 && K == 0) begin
            Q <= 1; // Set
        end
        else if (J == 0 && K == 1) begin
            Q <= 0; // Reset
        end
        else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle
        end
        // If J == 0 and K == 0, Q remains unchanged
    end
endmodule