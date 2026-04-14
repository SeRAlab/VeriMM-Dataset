module top_module(i, o);input i; 
  output o; 
  parameter io_standard = "NONE"; 
  parameter location = "NONE"; 
  parameter enable_bus_hold = "NONE"; 
  parameter weak_pull_up_resistor = "NONE"; 
  parameter termination = "NONE"; 
  parameter lpm_type = "alt_inbuf"; 
  assign o = i; 
 endmodule