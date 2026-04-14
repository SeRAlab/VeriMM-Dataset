module sr_flip_flop (
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
            // Undefined state, keep Q as is
        end
        // If S=0 and R=0, Q remains unchanged
    end
endmodule