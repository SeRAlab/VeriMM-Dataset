module top_module(

  

  adc_clk,
  adc_valid_in,
  adc_data_in,
  adc_data_pn,

  

  adc_pn_oos,
  adc_pn_err);parameter DATA_WIDTH = 16;
  localparam DW = DATA_WIDTH - 1;

  

  input           adc_clk;
  input           adc_valid_in;
  input   [DW:0]  adc_data_in;
  input   [DW:0]  adc_data_pn;

  

  output          adc_pn_oos;
  output          adc_pn_err;

  

  reg             adc_valid_d = 'd0;
  reg             adc_pn_match_d = 'd0;
  reg             adc_pn_match_z = 'd0;
  reg             adc_pn_err = 'd0;
  reg             adc_pn_oos = 'd0;
  reg     [ 3:0]  adc_pn_oos_count = 'd0;

  

  wire            adc_pn_match_d_s;
  wire            adc_pn_match_z_s;
  wire            adc_pn_match_s;
  wire            adc_pn_update_s;
  wire            adc_pn_err_s;

  

  assign adc_pn_match_d_s = (adc_data_in == adc_data_pn) ? 1'b1 : 1'b0;
  assign adc_pn_match_z_s = (adc_data_in == 'd0) ? 1'b0 : 1'b1;
  assign adc_pn_match_s = adc_pn_match_d & adc_pn_match_z;
  assign adc_pn_update_s = ~(adc_pn_oos ^ adc_pn_match_s);
  assign adc_pn_err_s = ~(adc_pn_oos | adc_pn_match_s);

  

  always @(posedge adc_clk) begin
    adc_valid_d <= adc_valid_in;
    adc_pn_match_d <= adc_pn_match_d_s;
    adc_pn_match_z <= adc_pn_match_z_s;
    if (adc_valid_d == 1'b1) begin
      adc_pn_err <= adc_pn_err_s;
      if ((adc_pn_update_s == 1'b1) && (adc_pn_oos_count >= 15)) begin
        adc_pn_oos <= ~adc_pn_oos;
      end
      if (adc_pn_update_s == 1'b1) begin
        adc_pn_oos_count <= adc_pn_oos_count + 1'b1;
      end else begin
        adc_pn_oos_count <= 'd0;
      end
    end
  end

endmodule