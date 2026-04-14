module top_module(
    input clk,
    input reset_n,
    input enable,
    output reg [2:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the counter to 3'b000
            q <= 3'b000;
        end else if (enable) begin
            // Binary counter: Increment by 1 when enabled
            q <= q + 1;
        end
    end

endmodule