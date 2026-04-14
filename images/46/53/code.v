module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the flip-flop chain to 3'b000
            q <= 3'b000;
        end else begin
            // T flip-flop chain
            q[0] <= ~q[0];
            q[1] <= q[0] ? ~q[1] : q[1];
            q[2] <= q[1] ? ~q[2] : q[2];
        end
    end

endmodule