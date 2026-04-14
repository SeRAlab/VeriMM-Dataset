module top_module(
  input clk, CinWire1, immBit1,
  input [31:0] abusWire1, bbusWire1, DselectWire1, immWire1,
  input [2:0] SWire1,
  input [1:0] lwSwFlag1,
  output reg CinWire2, immBit2,
  output reg [31:0] abusWire2, bbusWire2, DselectWire2, immWire2,
  output reg [2:0] SWire2,
  output reg [1:0] lwSwFlag2
);always @(posedge clk) begin
    abusWire2 <= abusWire1;
    bbusWire2 <= bbusWire1;
    DselectWire2 <= DselectWire1;
    immWire2 <= immWire1;
    SWire2 <= SWire1;
    CinWire2 <= CinWire1;
    immBit2 <= immBit1;
    lwSwFlag2 <= lwSwFlag1;
  end

endmodule