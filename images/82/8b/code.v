module top_module(pop, sram_data_out, sram_start,wb_clk, wb_rst, empty, full, grant, fifo_number_samples,fifo_number_samples_terminal, data_done, fifo_data_in);parameter dw=32; 
  input wb_clk; 
  input wb_rst; 
  input empty; 
  input full; 
  input grant; 
  input [5:0] fifo_number_samples; 
  input [5:0] fifo_number_samples_terminal; 
  input data_done; 
  output wire pop; 
  input [dw-1:0] fifo_data_in; 
  output reg [dw-1:0] sram_data_out; 
  output reg sram_start; 
  reg active; 
  assign pop = data_done; 
  always @(posedge wb_clk) 
  if (wb_rst) begin 
  active <= 0; 
  end else begin 
  if (empty) begin 
  active <= 0; 
  end else if ((fifo_number_samples >= fifo_number_samples_terminal) && !active) begin 
  active <= 1; 
  end 
  end 
  always @(posedge wb_clk) 
  if (wb_rst) begin 
  sram_data_out <= 0; 
  sram_start <= 0; 
  end else begin 
 if ((active && !pop) ||(data_done & !empty)) begin 
  sram_data_out <= fifo_data_in; 
  sram_start <= 1; 
  end else if (grant) begin 
  sram_start <= 0; 
  end else begin 
  end 
  end 
 endmodule