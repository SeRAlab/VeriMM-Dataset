module top_module(clk, dbusWire1, DselectWire2, bbusWire2, lwSwFlag2, dbusWire2, DselectWire3,bbusWire3,lwSwFlag3,branchControlBitWire1,
branchControlBitWire2,NOPWire1,NOPWire2);input clk;
  input [63:0] dbusWire1, bbusWire2;
  input [31:0] DselectWire2;
  input [1:0] lwSwFlag2;
  input [2:0] branchControlBitWire1;
  input NOPWire1;
  output [63:0] dbusWire2, bbusWire3;
  output [31:0] DselectWire3;
  output [1:0] lwSwFlag3;
  output [2:0] branchControlBitWire2;
  output NOPWire2;
  reg [63:0] dbusWire2, bbusWire3;
  reg [31:0] DselectWire3;
  reg [1:0] lwSwFlag3;
  reg [2:0] branchControlBitWire2;
  reg NOPWire2;
  always @(posedge clk) begin
    dbusWire2 = dbusWire1;
    DselectWire3 = DselectWire2;
    bbusWire3 = bbusWire2;
    lwSwFlag3 = lwSwFlag2;
    branchControlBitWire2 = branchControlBitWire1;
    NOPWire2 = NOPWire1;
  end
endmodule