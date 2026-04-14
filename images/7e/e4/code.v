module top_module(input wire clk,input wire hpix,input wire vpix,input wire hblank,input wire vblank,input wire [ 3:0] pixels,input wire [ 3:0] border,input wire atm_palwr,input wire [ 5:0] atm_paldata,output reg [ 5:0] palcolor,output wire [ 5:0] color);wire [ 3:0] zxcolor; 
  reg win; 
  reg [3:0] border_r; 
  assign zxcolor = (hpix&vpix) ? pixels : border; 
  reg [5:0] palette [0:15]; 
  always @(posedge clk) 
  begin 
  if( atm_palwr ) 
  palette[zxcolor] <= atm_paldata; 
  palcolor <= palette[zxcolor]; 
  end 
  assign color = (hblank | vblank) ? 6'd0 : palcolor; 
 endmodule