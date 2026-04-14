module top_module(reset, chip_resetb,hard_reset, soft_reset);input hard_reset; 
  input soft_reset; 
  output reset; 
  output chip_resetb; 
  assign reset = hard_reset | soft_reset; 
  assign chip_resetb = ~(hard_reset | soft_reset); 
 endmodule