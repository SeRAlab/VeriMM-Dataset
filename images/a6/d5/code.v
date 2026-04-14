module top_module(
    input clk,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (enable) begin
            // Counter increments when enabled
            q <= q + 1;
        end
    end

endmodule