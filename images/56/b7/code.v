module top_module(clk, dbusWire1, DselectWire2, bbusWire2, lwSwFlag2, dbusWire2, DselectWire3,bbusWire3,lwSwFlag3);input clk;
  input [31:0] dbusWire1, DselectWire2, bbusWire2;
  input [1:0] lwSwFlag2;
  output [31:0] dbusWire2, DselectWire3, bbusWire3;
  output [1:0] lwSwFlag3;
  reg [31:0] dbusWire2, DselectWire3, bbusWire3;
  reg [1:0] lwSwFlag3;
  always @(posedge clk) begin
    dbusWire2 = dbusWire1;
    DselectWire3 = DselectWire2;
    bbusWire3 = bbusWire2;
    lwSwFlag3 = lwSwFlag2;
  end
endmodule