module top_module(
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 <interface_name> RxD" *)
  input m_rxd, 
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 <interface_name> TxD" *)
  output m_txd, 
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 <interface_name> RTSn" *)
  output m_rtsn, 
  (* X_INTERFACE_INFO = "xilinx.com:interface:uart:1.0 <interface_name> CTSn" *)
  input m_ctsn, 

  input acia_tx,
  output acia_rx
  
);assign m_txd = acia_tx;
assign acia_rx = m_rxd;

endmodule