module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1'b1; // Set
        end
        else if (~S && R) begin
            Q <= 1'b0; // Reset
        end
        // if both S and R are low, Q holds its state (No action)
        // if both S and R are high, Q holds its state (Invalid state)
    end
endmodule