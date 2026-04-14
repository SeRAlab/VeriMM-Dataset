module top_module(cnt,rst,clk);input rst,clk;
  output [3:0] cnt;
  reg [3:0] cnt;
  
  always @(posedge clk) begin
    if(rst==1) begin
      cnt<=4'b0;
    end
    else begin
      cnt<=cnt+1;
    end
  end
endmodule