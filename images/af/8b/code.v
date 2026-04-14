module top_module(clk, rst,out_le, slt0, slt1, slt2, slt3, slt4,slt6,sdata_in);input clk, rst; 
 input [5:0] out_le; 
 output [15:0] slt0; 
 output [19:0] slt1; 
 output [19:0] slt2; 
 output [19:0] slt3; 
 output [19:0] slt4; 
 output [19:0] slt6; 
 input sdata_in; 
 reg sdata_in_r; 
 reg [19:0] sr; 
 reg [15:0] slt0; 
 reg [19:0] slt1; 
 reg [19:0] slt2; 
 reg [19:0] slt3; 
 reg [19:0] slt4; 
 reg [19:0] slt6; 
 always @(posedge clk) 
  if(out_le[0]) slt0 <= #1 sr[15:0]; 
 always @(posedge clk) 
  if(out_le[1]) slt1 <= #1 sr; 
 always @(posedge clk) 
  if(out_le[2]) slt2 <= #1 sr; 
 always @(posedge clk) 
  if(out_le[3]) slt3 <= #1 sr; 
 always @(posedge clk) 
  if(out_le[4]) slt4 <= #1 sr; 
 always @(posedge clk) 
  if(out_le[5]) slt6 <= #1 sr; 
 always @(negedge clk) 
  sdata_in_r <= #1 sdata_in; 
 always @(posedge clk) 
  sr <= #1 {sr[18:0], sdata_in_r }; 
 endmodule