module top_module(clk, dbusWire1, DselectWire2, dbusWire2, DselectWire3);input clk; 
  input [31:0] dbusWire1, DselectWire2; 
  output [31:0] dbusWire2, DselectWire3; 
  reg [31:0] dbusWire2, DselectWire3; 
  always @(posedge clk) begin 
  dbusWire2 = dbusWire1; 
  DselectWire3 = DselectWire2; 
  end 
 endmodule