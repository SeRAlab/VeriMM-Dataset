module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    // Always block triggered on the rising edge of the clock
    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0;
        end else if (enable) begin
            q <= q + 1'b1;
        end
    end

endmodule