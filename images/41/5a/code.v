module top_module(output DBP,input [7:0] DBx,input EN);wire tmp = 1 ^ DBx[0]; 
  wire tmpa = DBx[1] ^ DBx[2]; 
  wire tmpb = DBx[3] ^ DBx[4]; 
  wire tmpc = DBx[5] ^ DBx[6] ^ DBx[7]; 
  assign DBP = EN ? tmp ^ tmpa ^ tmpb ^ tmpc : 0; 
 endmodule