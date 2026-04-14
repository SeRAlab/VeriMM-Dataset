module top_module(IFIDRs,IFIDRt,IDEXRt,EXMEMRt,IDEXMemRd,EXMEMMemRd,datahazard,flushIDEX);input [4:0] IFIDRs;
input [4:0] IFIDRt;
input [4:0] IDEXRt;
input [4:0] EXMEMRt;
input IDEXMemRd;
input EXMEMMemRd;
output datahazard;
reg datahazard;
output flushIDEX;
reg flushIDEX;

always @(*)
begin
  if(IDEXMemRd)
  begin
    if(IDEXRt == IFIDRs || IDEXRt == IFIDRt)
    begin
      datahazard <= 1;
      flushIDEX <= 1;
    end
    else
    begin
      datahazard <= 0;
      flushIDEX <= 0;
    end
  end
  else
  begin
    datahazard <= 0;
    flushIDEX <= 0;
  end
  if(EXMEMMemRd)
  begin
    if(EXMEMRt == IFIDRs || EXMEMRt == IFIDRt)
    begin
      datahazard <= 1;
      flushIDEX <= 1;
    end
    else
    begin
      datahazard <= 0;
      flushIDEX <= 0;
    end
  end
  else
  begin
    datahazard <= 0;
    flushIDEX <= 0;
  end
end


endmodule