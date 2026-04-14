module top_module(clk, abusWire1, bbusWire1, DselectWire1, immWire1, SWire1, CinWire1,immBit1,abusWire2,bbusWire2,immWire2,SWire2,CinWire2,DselectWire2,immBit2);input clk, CinWire1,immBit1;
  input [31:0] abusWire1, bbusWire1, DselectWire1, immWire1;
  input [2:0] SWire1;
  output CinWire2,immBit2;
  output [31:0] abusWire2, bbusWire2, DselectWire2, immWire2;
  output [2:0] SWire2;
  reg CinWire2,immBit2;
  reg [31:0] abusWire2, bbusWire2, DselectWire2, immWire2;
  reg [2:0] SWire2;
  always @(posedge clk) begin
    abusWire2 <= abusWire1;
    bbusWire2 <= bbusWire1;
    DselectWire2 <= DselectWire1;
    immWire2 <= immWire1;
    SWire2 <= SWire1;
    CinWire2 <= CinWire1;
    immBit2 <= immBit1;
  end
endmodule