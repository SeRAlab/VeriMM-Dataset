module top_module(input clk,load,loadORtxce,input [7:0] d,output reg txpin, txbusy);reg [9:0] a; 
 `ifdef SIMULATION 
  initial begin txbusy = 0; txpin = 0; a = 0; end 
 `endif 
  always @(posedge clk) 
  if ( loadORtxce ) begin 
  a[9:0] <= load ? ~{1'b0,d,1'b0} : {1'b0,a[9:1]}; 
  txbusy <= load | |a[9:1]; 
  txpin <= (load & txpin) | (!load & |a[9:1] & a[0]); 
  end 
 endmodule