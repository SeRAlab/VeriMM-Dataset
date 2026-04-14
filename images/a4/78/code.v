module d_flip_flop(
    input clk,
    input reset,
    input d,
    output reg q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 1'b0;  // Asynchronous reset to zero
        end else begin
            q <= d;  // Otherwise, q follows the input d
        end
    end

endmodule