module top_module(i, o, obar);input i; 
  output o; 
  output obar; 
  parameter io_standard = "NONE"; 
  parameter current_strength = "NONE"; 
  parameter current_strength_new = "NONE"; 
  parameter slew_rate = -1; 
  parameter location = "NONE"; 
  parameter enable_bus_hold = "NONE"; 
  parameter weak_pull_up_resistor = "NONE"; 
  parameter termination = "NONE"; 
  parameter lpm_type = "alt_outbuf_diff"; 
  assign o = i; 
  assign obar = !i; 
 endmodule