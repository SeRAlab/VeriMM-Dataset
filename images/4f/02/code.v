module top_module(clk_i,rst_i,ena_i,strobe_i,tx_i_i,tx_q_i,tx_data_o,tx_sync_o);input clk_i;
   input rst_i;
   input ena_i;
   input strobe_i;
   
   input [13:0] tx_i_i;
   input [13:0] tx_q_i;

   output [13:0] tx_data_o;
   output 	 tx_sync_o;

`ifdef TX_RATE_MAX
   wire clk128;
   reg clk64_d;
   reg [13:0] tx_data_o;
   
   
   dacpll pll128(.areset(rst_i),.inclk0(clk_i),.c0(clk128));

   
   always @(posedge clk128)
     clk64_d <= clk_i;

   
   always @(posedge clk128)
     tx_data_o <= clk64_d ? tx_i_i : tx_q_i;

   assign tx_sync_o = clk64_d;
   

`else 
   assign tx_data_o = strobe_i ? tx_i_i : tx_q_i;
   assign tx_sync_o = strobe_i;
`endif 
   
endmodule