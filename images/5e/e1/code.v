module top_module(IFIDRs,IFIDRt,IDEXRs,IDEXRt,IDEXRd,EXMEMRd,MEMWBRd,IDEXRegWr,EXMEMRegWr,MEMWBRegWr,forwardA,forwardB,forward1,forward2);input [4:0] IFIDRs;
input [4:0] IFIDRt;
input [4:0] IDEXRs;
input [4:0] IDEXRt;
input [4:0] IDEXRd;
input [4:0] EXMEMRd;
input [4:0] MEMWBRd;
input IDEXRegWr;
input EXMEMRegWr;
input MEMWBRegWr;
output [1:0] forwardA;
reg [1:0] forwardA;
output [1:0] forwardB;
reg [1:0] forwardB;
output [1:0] forward1;
reg [1:0] forward1;
output [1:0] forward2;
reg [1:0] forward2;

always @(*)
begin
  if(EXMEMRegWr && EXMEMRd != 5'h0 && EXMEMRd == IDEXRs) forwardA <= 2'b10;
  else
  begin
    if(MEMWBRegWr && MEMWBRd != 5'h0 && EXMEMRd != IDEXRs && MEMWBRd == IDEXRs) forwardA <= 2'b01;
    else forwardA <= 2'b00;
  end
  if(EXMEMRegWr && EXMEMRd != 5'h0 && EXMEMRd == IDEXRt) forwardB <= 2'b10;
  else
  begin
    if(MEMWBRegWr && MEMWBRd != 5'h0 && EXMEMRd != IDEXRt && MEMWBRd == IDEXRt) forwardB <= 2'b01;
    else forwardB <= 2'b00;
  end
  if(IDEXRegWr && IDEXRd != 5'h0 && IDEXRd == IFIDRs) forward1 <= 2'b01;
  else
  begin
    if(EXMEMRegWr && EXMEMRd != 5'h0 && IDEXRd != IFIDRs && EXMEMRd == IFIDRs) forward1 <= 2'b10;
    else
    begin
      if(MEMWBRegWr && MEMWBRd != 5'h0 && IDEXRd != IFIDRs && EXMEMRd != IFIDRs && MEMWBRd == IFIDRs) forward1 <= 2'b11;
      else forward1 <= 2'b00;
    end
  end
  if(IDEXRegWr && IDEXRd != 5'h0 && IDEXRd == IFIDRt) forward2 <= 2'b01;
  else
  begin
    if(EXMEMRegWr && EXMEMRd != 5'h0 && IDEXRd != IFIDRt && EXMEMRd == IFIDRt) forward2 <= 2'b10;
    else
    begin
      if(MEMWBRegWr && MEMWBRd != 5'h0 && IDEXRd != IFIDRt && EXMEMRd != IFIDRt && MEMWBRd == IFIDRt) forward2 <= 2'b11;
      else forward2 <= 2'b00;
    end
  end
end

endmodule