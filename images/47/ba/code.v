module top_module(ESEL,IE,OSEL,OQI,OQE,DS,FIXHOLD,IZ,IQZ,IQE,IQC,IQCS,IQR,WPD,INEN,IP);input ESEL; 
  input IE; 
  input OSEL; 
  input OQI; 
  input OQE; 
  input DS; 
  input FIXHOLD; 
  output IZ; 
  output IQZ; 
  input IQE; 
  input IQC; 
  input IQCS; 
  input INEN; 
  input IQR; 
  input WPD; 
  inout IP; 
  reg EN_reg, OQ_reg, IQZ; 
  wire AND_OUT; 
  assign rstn = ~IQR; 
  assign IQCP = IQCS ? ~IQC : IQC; 
  always @(posedge IQCP or negedge rstn) 
  if (~rstn) EN_reg <= 1'b0; 
  else EN_reg <= IE; 
  always @(posedge IQCP or negedge rstn) 
  if (~rstn) OQ_reg <= 1'b0; 
  else if (OQE) OQ_reg <= OQI; 
  always @(posedge IQCP or negedge rstn) 
  if (~rstn) IQZ <= 1'b0; 
  else if (IQE) IQZ <= AND_OUT; 
  assign IZ = AND_OUT; 
  assign AND_OUT = INEN ? IP : 1'b0; 
  assign EN = ESEL ? IE : EN_reg; 
  assign OQ = OSEL ? OQI : OQ_reg; 
  assign IP = EN ? OQ : 1'bz; 
 endmodule