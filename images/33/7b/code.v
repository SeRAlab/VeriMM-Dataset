module sr_latch (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (R)
            Q <= 0; // Reset state
        else if (S)
            Q <= 1; // Set state
        // If both S and R are high, do nothing (latch)
    end
endmodule