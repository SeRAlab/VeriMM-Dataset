module top_module (
    input clk,
    input d,
    input reset,
    output reg q
);

    // D flip-flop with asynchronous reset logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule