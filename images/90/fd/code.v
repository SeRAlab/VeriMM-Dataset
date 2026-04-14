module top_module(reset, clk, dclk);input reset, clk;
    output dclk;
    
reg [2:0] cnt;

assign dclk = cnt[2];

always @ (posedge clk or posedge reset)
   if(reset) cnt <= 3'd0;
   else cnt <= cnt+1'b1;

endmodule