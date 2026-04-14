module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R)
            Q <= 1; // Set
        else if (!S && R)
            Q <= 0; // Reset
        // If both S and R are low, retain Q
        // If both S and R are high, the output is undefined
    end
endmodule