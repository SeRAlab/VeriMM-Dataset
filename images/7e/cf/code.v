module top_module(input wire clk,input wire i,output wire [7:0] m_eth_payload_axis_tkeep);reg [7:0] m_eth_payload_axis_tkeep_reg = 8'd0; 
  assign m_eth_payload_axis_tkeep = m_eth_payload_axis_tkeep_reg; 
  always @(posedge clk) 
  m_eth_payload_axis_tkeep_reg <= i ? 8'hff : 8'h0f; 
 endmodule