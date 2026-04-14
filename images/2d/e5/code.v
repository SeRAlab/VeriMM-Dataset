module jk_latch (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 1'b0 && K == 1'b0) begin
            // No change
            Q <= Q;
        end else if (J == 1'b1 && K == 1'b0) begin
            // Set
            Q <= 1'b1;
        end else if (J == 1'b0 && K == 1'b1) begin
            // Reset
            Q <= 1'b0;
        end else if (J == 1'b1 && K == 1'b1) begin
            // Toggle
            Q <= ~Q;
        end
    end
endmodule