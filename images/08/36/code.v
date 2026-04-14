module sr_flip_flop(
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1; // Set
        end else if (!S && R) begin
            Q <= 0; // Reset
        end else if (S && R) begin
            Q <= Q; // Undefined behavior
        end // Hold state when S = 0 and R = 0 is implicit
    end
endmodule