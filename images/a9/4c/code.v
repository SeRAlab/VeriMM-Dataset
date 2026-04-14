module top_module(RX_CLK_COR_CNT,CHANNEL_BOND_LOAD,USER_CLK);`define DLY #1 
  parameter CHANNEL_BOND_LOAD_CODE = 3'b101; 
  input [2:0] RX_CLK_COR_CNT; 
  output CHANNEL_BOND_LOAD; 
  input USER_CLK; 
  reg CHANNEL_BOND_LOAD; 
  always @(posedge USER_CLK) 
  CHANNEL_BOND_LOAD <= (RX_CLK_COR_CNT == CHANNEL_BOND_LOAD_CODE); 
 endmodule