module JK_Latch (
    input J,
    input K,
    input clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J == 1 && K == 0)
            Q <= 1;         // Set
        else if (J == 0 && K == 1)
            Q <= 0;         // Reset
        else if (J == 1 && K == 1)
            Q <= ~Q;        // Toggle
        // else retain previous state
    end
endmodule