module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && ~R) begin
            Q <= 1'b1; // Set
        end else if (~S && R) begin
            Q <= 1'b0; // Reset
        end // If both S and R are 0, Q remains unchanged
        // If both S and R are 1, Q can be left as it is (undefined behavior)
    end
endmodule