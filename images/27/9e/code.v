module jk_flip_flop (
    input wire J,
    input wire K,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (J && K) begin
            Q <= ~Q; // Toggle
        end else if (J && !K) begin
            Q <= 1; // Set
        end else if (!J && K) begin
            Q <= 0; // Reset
        end
        // else Q remains unchanged
    end
endmodule