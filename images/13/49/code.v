module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && ~R) 
            Q <= 1;  // Set
        else if (~S && R) 
            Q <= 0;  // Reset
        // If S=0 and R=0, Q retains its previous state
        // If S=1 and R=1, Q retains its previous state
    end
endmodule