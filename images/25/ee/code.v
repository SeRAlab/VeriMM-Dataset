module jk_latch (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 0 && K == 0) begin
            Q <= Q; // No change
        end else if (J == 1 && K == 0) begin
            Q <= 1; // Set Q
        end else if (J == 0 && K == 1) begin
            Q <= 0; // Reset Q
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle Q
        end
    end
endmodule