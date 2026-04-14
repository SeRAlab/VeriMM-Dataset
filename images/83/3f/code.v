module top_module(input gpio_sel,input tri_i_out,output reg tri_o_out,output reg tri_t_out,output tri_i_in,input tri_o_in,input tri_t_in,output rx_i_in,input tx_o_in,input tx_t_in);reg [1:0] tri_i_out_demux; 
  assign {rx_i_in, tri_i_in} = tri_i_out_demux; 
  always @(gpio_sel, tri_o_in, tx_o_in) 
  case (gpio_sel) 
  1'h0: tri_o_out = tri_o_in; 
  1'h1: tri_o_out = tx_o_in; 
  endcase 
  always @(gpio_sel, tri_i_out) 
  begin 
  tri_i_out_demux = {2{1'b0}}; 
  case (gpio_sel) 
  1'h0: tri_i_out_demux[0] = tri_i_out; 
  1'h1: tri_i_out_demux[1] = tri_i_out; 
  endcase 
  end 
  always @(gpio_sel, tri_t_in, tx_t_in) 
  case (gpio_sel) 
  1'h0: tri_t_out = tri_t_in; 
  1'h1: tri_t_out = tx_t_in; 
  endcase 
 endmodule