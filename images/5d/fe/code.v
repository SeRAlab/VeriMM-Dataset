module top_module(nrst, clkin, bypass, clkout);input nrst; 
  input clkin; 
  input bypass; 
  output clkout; 
  reg [2:0] cnt; 
  always @(posedge clkin or negedge nrst) begin 
  if (~nrst) begin 
  cnt <= 0; 
  end else begin 
  cnt <= cnt + 1'b1; 
  end 
  end 
  assign clkout = bypass ? clkin : cnt[2]; 
 endmodule