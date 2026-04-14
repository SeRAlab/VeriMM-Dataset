module top_module(
    input clk,
    input reset,
    output reg [1:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 2'b00;
        end else begin
            // Johnson counter: Rotate the bits and complement the new bit
            q <= {q[0], ~q[1]};
        end
    end

endmodule