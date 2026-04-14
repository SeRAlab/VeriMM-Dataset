module binary_counter(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else if (enable) begin
            q <= q + 1;
        end
    end

endmodule