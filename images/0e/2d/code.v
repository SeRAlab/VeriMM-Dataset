module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && ~R)
            Q <= 1'b1;      // Set
        else if (~S && R)
            Q <= 1'b0;      // Reset
        // If S = 0 and R = 0, maintain Q
        // If S = 1 and R = 1, do nothing (invalid state)
    end
endmodule