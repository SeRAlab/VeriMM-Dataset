module top_module(input [1:0] wnd,input init,clk,rst,output reg [1:0] w);always @(posedge clk , posedge rst) begin
    if(rst) w <= 2'b0;
  else begin
    if(init) w<= 2'b 0;
    else w <= wnd;
    end
  end
endmodule