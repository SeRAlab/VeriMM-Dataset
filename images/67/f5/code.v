module top_module(

  

  dac_clk,
  dac_rd,
  dac_rdata,
  dac_runf,

  

  dma_clk,
  dma_rd,
  dma_rdata,
  dma_runf,

  

  fifo_rst,
  fifo_rstn,
  fifo_wr,
  fifo_wdata,
  fifo_wfull,
  fifo_rd,
  fifo_rdata,
  fifo_rempty,
  fifo_runf);parameter DAC_DATA_WIDTH = 32;
  parameter DMA_DATA_WIDTH = 64;
 
  

  input                           dac_clk;
  input                           dac_rd;
  output  [DAC_DATA_WIDTH-1:0]    dac_rdata;
  output                          dac_runf;

  

  input                           dma_clk;
  output                          dma_rd;
  input   [DMA_DATA_WIDTH-1:0]    dma_rdata;
  input                           dma_runf;

  

  output                          fifo_rst;
  output                          fifo_rstn;
  output                          fifo_wr;
  output  [DMA_DATA_WIDTH-1:0]    fifo_wdata;
  input                           fifo_wfull;
  output                          fifo_rd;
  input   [DAC_DATA_WIDTH-1:0]    fifo_rdata;
  input                           fifo_rempty;
  input                           fifo_runf;

  

  reg     [ 1:0]                  dac_runf_m = 'd0;
  reg                             dac_runf = 'd0;
  reg                             dma_rd = 'd0;

  

  always @(posedge dac_clk) begin
    dac_runf_m[0] <= dma_runf | fifo_runf;
    dac_runf_m[1] <= dac_runf_m[0];
    dac_runf <= dac_runf_m[1];
  end

  

  always @(posedge dma_clk) begin
    dma_rd <= ~fifo_wfull;
  end

  

  assign fifo_wr = dma_rd;

  genvar s;
  generate
  for (s = 0; s < DMA_DATA_WIDTH; s = s + 1) begin: g_wdata
  assign fifo_wdata[s] = dma_rdata[(DMA_DATA_WIDTH-1)-s];
  end
  endgenerate

  

  assign fifo_rd = ~fifo_rempty & dac_rd;

  genvar m;
  generate
  for (m = 0; m < DAC_DATA_WIDTH; m = m + 1) begin: g_rdata
  assign dac_rdata[m] = fifo_rdata[(DAC_DATA_WIDTH-1)-m];
  end
  endgenerate

  

  assign fifo_rst = 1'b0;
  assign fifo_rstn = 1'b1;

endmodule