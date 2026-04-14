module top_module(datain, dataout, latch_enable, aclr, preset);input datain, latch_enable, aclr, preset; 
  output dataout; 
  reg dataout; 
  always @(datain or latch_enable or aclr or preset) 
  begin 
  if (aclr === 1'b1) 
  dataout = 1'b0; 
  else if (preset === 1'b1) 
  dataout = 1'b1; 
  else if (latch_enable) 
  dataout = datain; 
  end 
 endmodule