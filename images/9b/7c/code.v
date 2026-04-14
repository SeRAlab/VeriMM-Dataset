module d_flip_flop(
    input clk,          // Clock signal.
    input rst_n,        // Active-low synchronous reset.
    input d,            // Data input.
    output reg q        // Data output.
);

// Flip-Flop logic
always @(posedge clk) begin
    if (!rst_n) begin
        q <= 0;
    end else begin
        q <= d;
    end
end

endmodule