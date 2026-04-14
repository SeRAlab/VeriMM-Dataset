module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;  // Synchronous reset to the initial state
        end else begin
            q <= q + 1;  // T-type flip-flop counter increment operation
        end
    end

endmodule