module top_module(wren, rden, reset, din, clk, stop, baud, dout);input wren, rden, reset, clk, stop; 
 input [7:0] din; 
 output baud; 
 output [7:0] dout; 
 parameter PERIOD = 8'h0F; 
 reg [7:0] timer, period, dout; 
 reg baud; 
 always @(posedge clk or posedge reset) begin 
  if(reset) 
  timer <= 8'h00; 
  else begin 
  timer <= timer + 1; 
  if(timer == period) 
  timer <= 8'h00; 
  if(stop) 
  timer <= 8'h00; 
  end 
 end 
 always @(posedge clk or posedge reset) begin 
  if(reset) 
  period <= PERIOD; 
  else begin 
  if(wren) 
  period <= din; 
  end 
 end 
 always @(posedge clk or posedge reset) begin 
  if(reset) 
  baud = 0; 
  else begin 
  if(timer == period) 
  baud = ~baud; 
  end 
 end 
 always @* begin 
 dout <= 8'b00000000; 
  if(rden) 
  dout <= period; 
 end 
 endmodule