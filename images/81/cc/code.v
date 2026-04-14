module top_module(d,q,clk,rst);input d,clk,rst;
output reg q;

always@(negedge clk )
begin
    q=d;
 end

endmodule