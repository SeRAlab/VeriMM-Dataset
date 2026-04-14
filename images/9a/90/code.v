module top_module(d,clk,resetn,en,squash,q);parameter WIDTH=32; 
 parameter DEPTH=1; 
 parameter RESETVALUE={WIDTH{1'b0}}; 
 input [WIDTH-1:0] d; 
 input clk; 
 input resetn; 
 input [DEPTH-1:0] en; 
 input [DEPTH-1:0] squash; 
 output [WIDTH*DEPTH-1:0] q; 
 reg [WIDTH*DEPTH-1:0] q; 
 integer i; 
  always@(posedge clk or negedge resetn) 
  begin 
  if ( !resetn ) 
  q[ WIDTH-1:0 ]<=RESETVALUE; 
  else if ( squash[0] ) 
  q[ WIDTH-1:0 ]<=RESETVALUE; 
  else if (en[0]) 
  q[ WIDTH-1:0 ]<=d; 
  for (i=1; i<DEPTH; i=i+1) 
  if (!resetn) 
  q[i*WIDTH +: WIDTH ]<=RESETVALUE; 
  else if ( squash[i] ) 
  q[i*WIDTH +: WIDTH ]<=RESETVALUE; 
  else if (en[i]) 
  q[i*WIDTH +: WIDTH ]<=q[(i-1)*WIDTH +: WIDTH ]; 
  end 
 endmodule