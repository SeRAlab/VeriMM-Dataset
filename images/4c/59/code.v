module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;  // Synchronous reset to the initial state
        end else begin
            q <= {q[2:0], ~q[3]};  // Johnson counter shift operation
        end
    end

endmodule