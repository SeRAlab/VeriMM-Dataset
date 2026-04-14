module SR_Latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && R)
            Q <= Q; // Invalid state, maintain previous state
        else if (S)
            Q <= 1;  // Set Q to 1
        else if (R)
            Q <= 0;  // Reset Q to 0
    end
endmodule