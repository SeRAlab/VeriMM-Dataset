module top_module(reset,inc,cnt,clk);input reset, inc, clk;
output reg [5:0] cnt;

always @ (posedge clk)
begin
    if(reset)
        cnt = 1'd1;
    else
        begin
        if(inc)
        cnt <= cnt+1'd1;
        end
end
endmodule