module top_module(d,clk,resetn,squashn,en,q);//parameter WIDTH=32;

input clk;
input resetn;
input en;
input squashn;
input [31:0] d;
output [31:0] q;
reg [31:0] q;
reg squash_save;

  always @(posedge clk)   //synchronous reset
  begin
    if (resetn==0 || (squashn==0 && en==1) || (squash_save&en))
      q<=0;
    else if (en==1)
      q<=d;
  end

  always @(posedge clk)
  begin
    if (resetn==1 && squashn==0 && en==0)
      squash_save<=1;
    else
      squash_save<=0;
  end
endmodule