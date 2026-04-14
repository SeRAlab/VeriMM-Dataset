module top_module(input SPO, DPO, output SPO_OUT, DPO_OUT);// Remove the wire declarations here as they are redundant due to the output declaration.
  assign SPO_OUT = SPO; 
  assign DPO_OUT = DPO; 
endmodule