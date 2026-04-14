module top_module(
    input clk,
    input reset,
    input d,
    output reg q,
    output reg q_n
);always @(posedge clk or negedge reset) begin
        if (~reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

    assign q_n = ~q;

endmodule