module top_module (
    input clk,
    input reset,
    input d,
    output reg q
);

    // Synchronous reset D flip-flop logic
    always @(posedge clk) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule