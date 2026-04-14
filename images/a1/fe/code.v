module top_module(input clk, input reset, input clear,input [18:0] datain, input src_rdy_i, output dst_rdy_o,output [18:0] dataout, output src_rdy_o, input dst_rdy_i);reg rxre_state; 
  localparam RXRE_DUMMY = 0; 
  localparam RXRE_PKT = 1; 
  assign dataout[18] = datain[18]; 
  assign dataout[17] = datain[17]; 
  assign dataout[16] = (rxre_state==RXRE_DUMMY) | (datain[17] & datain[16]); 
  assign dataout[15:0] = datain[15:0]; 
  always @(posedge clk) 
  if(reset | clear) 
  rxre_state <= RXRE_DUMMY; 
  else if(src_rdy_i & dst_rdy_i) 
  case(rxre_state) 
  RXRE_DUMMY : 
  rxre_state <= RXRE_PKT; 
  RXRE_PKT : 
  if(datain[17]) 
  rxre_state <= RXRE_DUMMY; 
  endcase 
  assign src_rdy_o = src_rdy_i & dst_rdy_i; 
  assign dst_rdy_o = src_rdy_i & dst_rdy_i & (rxre_state == RXRE_PKT); 
 endmodule