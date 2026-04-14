module sr_flip_flop(
    input wire S,
    input wire R,
    input wire E,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (E) begin
            if (R) 
                Q <= 0; // Reset
            else if (S) 
                Q <= 1; // Set
            // If both S and R are low, keep the current state
        end
    end
endmodule