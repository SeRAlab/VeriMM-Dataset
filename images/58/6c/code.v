module top_module(clk, dbusWire2, DselectWire3, bbusWire3, lwSwFlag3, dbusWire3, DselectWire4,bbusWire4,lwSwFlag4,branchControlBitWire2,branchControlBitWire3);input clk;
  input [31:0] dbusWire2, DselectWire3, bbusWire3;
  input [1:0] lwSwFlag3;
  input [1:0] branchControlBitWire2;
  output [31:0] dbusWire3, DselectWire4, bbusWire4;
  output [1:0] lwSwFlag4;
  output [1:0] branchControlBitWire3;
  reg [31:0] dbusWire3, DselectWire4, bbusWire4;
  reg [1:0] lwSwFlag4;
  reg [1:0] branchControlBitWire3;
  always @(posedge clk) begin
    dbusWire3 = dbusWire2;
    DselectWire4 = DselectWire3;
    bbusWire4 = bbusWire3;
    lwSwFlag4 = lwSwFlag3;
    branchControlBitWire3 = branchControlBitWire2;
  end
endmodule