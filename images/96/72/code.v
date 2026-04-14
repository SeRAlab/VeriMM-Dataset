module top_module(
    input clk,
    input rst,
    input ena,
    output reg [3:0] q
);always @(posedge clk or negedge rst) begin
        if (~rst) begin
            q <= 4'b0000;
        end
        else if (ena) begin
            q <= q ^ (q >> 1);
        end
        else begin
            q <= q ^ (q >> 1) ^ 4'b0001;
        end
    end

endmodule