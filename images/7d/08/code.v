module top_module(
    input clk,
    input reset,
    input ena,
    input d,
    output reg q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the flip-flop to zero
            q <= 1'b0;
        end else if (ena) begin
            // Enable: Capture the data input
            q <= d;
        end
    end

endmodule