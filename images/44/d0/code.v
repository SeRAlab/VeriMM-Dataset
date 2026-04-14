module top_module(
    input clk,
    input enable,
    input reset,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;  // Synchronous reset to zero
        end else if (enable) begin
            q <= {q[2:0], ~q[3]};  // Johnson counter operation
        end
    end

endmodule