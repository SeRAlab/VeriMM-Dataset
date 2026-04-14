module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 0 && K == 0) begin
            Q <= Q; // No change
        end
        else if (J == 1 && K == 0) begin
            Q <= 1; // Set
        end
        else if (J == 0 && K == 1) begin
            Q <= 0; // Reset
        end
        else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle
        end
    end
endmodule