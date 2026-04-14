module sr_latch (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R)
            Q <= 1;  // Set
        else if (!S && R)
            Q <= 0;  // Reset
        // If both S and R are low, Q retains its state
    end
endmodule