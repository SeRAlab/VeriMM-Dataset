module top_module(input I,output O);parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_IN = 1'b0; 
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVDS_25_LVTTL_SSTL135_SSTL15_TMDS_33_IN_ONLY = 1'b0; 
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_LVCMOS25_LVCMOS33_LVTTL_SLEW_FAST = 1'b0; 
  parameter [0:0] LVCMOS12_LVCMOS15_LVCMOS18_SSTL135_SSTL15_STEPDOWN = 1'b0; 
  parameter [0:0] LVCMOS25_LVCMOS33_LVTTL_IN = 1'b0; 
  parameter [0:0] SSTL135_SSTL15_IN = 1'b0; 
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_40 = 1'b0; 
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_50 = 1'b0; 
  parameter [0:0] IN_TERM_UNTUNED_SPLIT_60 = 1'b0; 
  parameter [0:0] IBUF_LOW_PWR = 1'b0; 
  parameter [0:0] PULLTYPE_PULLUP = 1'b0; 
  parameter [0:0] PULLTYPE_PULLDOWN = 1'b0; 
  parameter [0:0] PULLTYPE_NONE = 1'b0; 
  parameter [0:0] PULLTYPE_KEEPER = 1'b0; 
  parameter PULLTYPE = ""; 
  parameter IOSTANDARD = ""; 
  assign O = I; 
 endmodule