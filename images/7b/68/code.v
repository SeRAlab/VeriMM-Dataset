module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 3'b000
            q <= 3'b000;
        end else begin
            // Johnson counter: Invert the MSB and shift right
            q <= {~q[2], q[2:1]};
        end
    end

endmodule