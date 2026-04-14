module top_module(clk, rst, en, count);parameter SIZE = 4;

input clk;
input rst;
input en;
output reg [SIZE-1:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule