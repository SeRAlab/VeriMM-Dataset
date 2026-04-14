module top_module(scndry_out,
    scndry_out2,
    prmry_in,
    ext_spi_clk);output scndry_out;
  output scndry_out2;
  input prmry_in;
  input ext_spi_clk;

  wire ext_spi_clk;
  wire prmry_in;
  wire s_level_out_d1_cdc_to;
  wire scndry_out;
  wire scndry_out2_wire = scndry_out;

  (* ASYNC_REG *) 
  (* BOX_TYPE = "PRIMITIVE" *) 
  reg s_level_out_d1_cdc_to_reg;
  always @(posedge ext_spi_clk) begin
    s_level_out_d1_cdc_to_reg <= prmry_in;
  end

  (* ASYNC_REG *) 
  (* BOX_TYPE = "PRIMITIVE" *) 
  reg scndry_out_reg;
  always @(posedge ext_spi_clk) begin
    scndry_out_reg <= s_level_out_d1_cdc_to_reg;
  end

  assign scndry_out = scndry_out_reg;
  
  reg scndry_out2_reg;
  always @(posedge ext_spi_clk) begin
    scndry_out2_reg <= scndry_out2_wire;
  end
  
  assign scndry_out2 = scndry_out2_reg;

endmodule