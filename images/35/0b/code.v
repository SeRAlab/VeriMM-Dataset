module JK_latch (
    input J,
    input K,
    input clk,
    output reg Q,
    output reg Q_not
);
    always @(posedge clk) begin
        if (J == 1 && K == 0) begin
            Q <= 1; // Set
        end else if (J == 0 && K == 1) begin
            Q <= 0; // Reset
        end else if (J == 1 && K == 1) begin
            Q <= ~Q; // Toggle
        end
        Q_not <= ~Q; // Q_not is always the inverse of Q
    end
endmodule