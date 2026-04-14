module SR_FlipFlop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && ~R) 
            Q <= 1; // set
        else if (~S && R) 
            Q <= 0; // reset
        // else case for S = 0 and R = 0: Hold the state
        // else case for S = 1 and R = 1: Indeterminate, we can keep the previous state
    end
endmodule