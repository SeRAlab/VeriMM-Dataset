module top_module (
    input clk,
    input reset,
    output reg [3:0] q
);

    // 4-bit binary counter with reset logic
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= q + 1;
        end
    end

endmodule