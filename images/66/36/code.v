module top_module(

  
  

  tx_clk,
  tx_data,

  

  dac_clk,
  dac_rst,
  dac_data_0_0,
  dac_data_0_1,
  dac_data_0_2,
  dac_data_0_3,
  dac_data_1_0,
  dac_data_1_1,
  dac_data_1_2,
  dac_data_1_3);input           tx_clk;
  output [127:0]  tx_data;

  

  output          dac_clk;
  input           dac_rst;
  input   [15:0]  dac_data_0_0;
  input   [15:0]  dac_data_0_1;
  input   [15:0]  dac_data_0_2;
  input   [15:0]  dac_data_0_3;
  input   [15:0]  dac_data_1_0;
  input   [15:0]  dac_data_1_1;
  input   [15:0]  dac_data_1_2;
  input   [15:0]  dac_data_1_3;

  

  reg    [127:0]  tx_data = 'd0;

  

  assign dac_clk = tx_clk;

  always @(posedge dac_clk) begin
    if (dac_rst == 1'b1) begin
      tx_data <= 128'd0;
    end else begin
      tx_data[127:120] <= dac_data_1_3[ 7: 0];
      tx_data[119:112] <= dac_data_1_2[ 7: 0];
      tx_data[111:104] <= dac_data_1_1[ 7: 0];
      tx_data[103: 96] <= dac_data_1_0[ 7: 0];
      tx_data[ 95: 88] <= dac_data_1_3[15: 8];
      tx_data[ 87: 80] <= dac_data_1_2[15: 8];
      tx_data[ 79: 72] <= dac_data_1_1[15: 8];
      tx_data[ 71: 64] <= dac_data_1_0[15: 8];
      tx_data[ 63: 56] <= dac_data_0_3[ 7: 0];
      tx_data[ 55: 48] <= dac_data_0_2[ 7: 0];
      tx_data[ 47: 40] <= dac_data_0_1[ 7: 0];
      tx_data[ 39: 32] <= dac_data_0_0[ 7: 0];
      tx_data[ 31: 24] <= dac_data_0_3[15: 8];
      tx_data[ 23: 16] <= dac_data_0_2[15: 8];
      tx_data[ 15:  8] <= dac_data_0_1[15: 8];
      tx_data[  7:  0] <= dac_data_0_0[15: 8];
    end
  end

endmodule