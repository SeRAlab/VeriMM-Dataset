module top_module(
    input clk,
    input rst,
    input d,
    output reg q,
    output reg q_n
);always @(posedge clk or negedge rst) begin
        if (!rst) begin
            q <= 1'b0;
            q_n <= 1'b1;
        end else begin
            q <= d;
            q_n <= ~d;
        end
    end

endmodule