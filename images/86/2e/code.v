module top_module(clk, rst_, data, addr, cs_, oe_, we_, interrupt);input clk; 
  input rst_; 
  inout [7:0] data; 
  input [7:0] addr; 
  input cs_; 
  input oe_; 
  input we_; 
  output interrupt; 
 reg [7:0] r[0:7]; 
 assign data = (~cs_ & ~oe_) ? r[addr] : 8'bzzzzzzzz; 
 `ifndef USE_RST_LOGIC 
 initial begin 
  { r[3], r[2], r[1], r[0] } = 32'd0; 
  { r[7], r[6], r[5], r[4] } = 32'd0; 
 end 
 `endif 
 always @(posedge clk) 
 `ifdef USE_RST_LOGIC 
  if(~rst_) begin 
  { r[3], r[2], r[1], r[0] } = 32'd0; 
  { r[7], r[6], r[5], r[4] } = 32'd0; 
  end 
  else 
 `endif 
  if(~cs_ & ~we_) 
  r[addr] <= data; 
  else 
  { r[3], r[2], r[1], r[0] } <= { r[3], r[2], r[1], r[0] } + 32'd1; 
 assign interrupt = ( { r[7], r[6], r[5], r[4] } == 32'd0 ) ? 1'b0 : 
  (( { r[3], r[2], r[1], r[0] } >= { r[7], r[6], r[5], r[4] } ) ? 1'b1 : 1'b0); 
 endmodule