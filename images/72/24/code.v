module top_module(
    input clk,
    input rst_n,
    output reg [3:0] Q
);always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            Q <= 4'b0000;
        end else begin
            Q <= Q + 1;
        end
    end

endmodule