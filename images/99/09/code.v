module top_module(
  input [31:0]  i_Paddr,
  input         i_Penable,
  input         i_Psel,
  input         i_Pwrite,
  output        o_Tx_En,
  output        o_Rx_En,
  output        o_Stw_En,
  output        o_Str_En
  );parameter c_ST = 2'b00; 
  parameter c_TX = 2'b01; 
  parameter c_RX = 2'b10; 

  wire       w_En   = (i_Penable & i_Psel);
  wire [1:0] w_Addr = (i_Paddr[31:30]);

  assign o_Stw_En = (w_En & (w_Addr == c_ST) & i_Pwrite);
  assign o_Str_En = (w_En & (w_Addr == c_ST) & !i_Pwrite);
  assign o_Tx_En  = (w_En & (w_Addr == c_TX) & i_Pwrite);
  assign o_Rx_En  = (w_En & (w_Addr == c_RX) & !i_Pwrite);

endmodule