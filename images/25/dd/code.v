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
        end else if (~S && ~R) begin
            // No change
        end else begin
            Q <= 1'bx; // Invalid state
        end
    end
endmodule