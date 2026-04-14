module top_module(clk, rst, count);input clk, rst;
output reg [3:0] count;

always @(posedge clk)
begin
    if(rst)
        count <= 4'b0000;
    else if(count == 4'b1111)
        count <= 4'b0000;
    else
        count <= count + 1;
end

endmodule