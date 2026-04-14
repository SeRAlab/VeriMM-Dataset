module top_module(
  input data_in,
  input clk,
  output data_out,
  output decoded_data_out
);reg data_out_reg;
  reg decoded_data_out_reg;
  reg prev_clk_state;
  
  always @(posedge clk) begin
    // Manchester Encoding
    data_out_reg <= data_in ^ prev_clk_state;
    prev_clk_state <= ~prev_clk_state;
  end
  
  always @(posedge prev_clk_state) begin
    // Manchester Decoding
    decoded_data_out_reg <= data_out_reg ^ prev_clk_state;
  end
  
  assign data_out = data_out_reg;
  assign decoded_data_out = decoded_data_out_reg;
  
endmodule