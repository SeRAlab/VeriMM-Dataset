module top_module(data, clk, clr, c,w, X, Y, sclk);localparam Nbits = 16;

input [Nbits-1:0] X; 
output [Nbits-1:0] Y;

input [15:0] data;
input clk, clr, c, w;
input sclk;

reg [7:0] cdelayK;
reg [7:0] cdelayL;

reg [15:0] cm1; 
reg [15:0] cm2;



always @(posedge clk)
begin
 if (clr) begin
  cdelayL <= 4;
  cdelayK <= 6;
  cm1 <= 64; 
  cm2 <= 64; 
 end
 else
 begin
  if (w)begin
   if (c) begin
    cdelayL <=data[15:8];
    cdelayK <=data[7:0];
   end
   else
   begin
    cm1 <={{8{1'b0}},data[7:0]};
    cm2 <={{8{1'b0}},data[15:8]};
   end
  end
 end
end
endmodule