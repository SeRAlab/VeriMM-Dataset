module top_module(
    input clk,
    input rst,
    input [31:0] limit,
    output reg [31:0] count
);always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
        end
        else if (count == limit) begin
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end

endmodule