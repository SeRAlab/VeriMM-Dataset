module debouncer #(
  parameter CN = 8,         
  parameter CW = $clog2(CN) 
)(
  input      clk,           
  input      d_i,           
  output reg d_o            
);
reg [CW-1:0] cnt;           
reg          d_r;           
initial cnt <= 0;
always @ (posedge clk)
d_r <= d_i;
always @ (posedge clk)
if (|cnt)          cnt <= cnt - 1;
else if (d_r^d_o)  cnt <= CN;
always @ (posedge clk)
if (~|cnt) d_o <= d_r;
endmodule