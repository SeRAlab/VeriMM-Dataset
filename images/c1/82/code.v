module dbg_crc8_d1 (Data, EnableCrc, Reset, SyncResetCrc, CrcOut, Clk);
parameter Tp = 1;
input Data;
input EnableCrc;
input Reset;
input SyncResetCrc;
input Clk;
output [7:0] CrcOut;
reg    [7:0] CrcOut;
function [7:0] nextCRC8_D1;
  input Data;
  input [7:0] Crc;
  reg [0:0] D;
  reg [7:0] C;
  reg [7:0] NewCRC;
  begin
    D[0] = Data;
    C = Crc;
    NewCRC[0] = D[0] ^ C[7];
    NewCRC[1] = D[0] ^ C[0] ^ C[7];
    NewCRC[2] = D[0] ^ C[1] ^ C[7];
    NewCRC[3] = C[2];
    NewCRC[4] = C[3];
    NewCRC[5] = C[4];
    NewCRC[6] = C[5];
    NewCRC[7] = C[6];
    nextCRC8_D1 = NewCRC;
  end
endfunction
always @ (posedge Clk or posedge Reset)
begin
  if(Reset)
    CrcOut[7:0] <= #Tp 0;
  else
  if(SyncResetCrc)
    CrcOut[7:0] <= #Tp 0;
  else
  if(EnableCrc)
    CrcOut[7:0] <= #Tp nextCRC8_D1(Data, CrcOut);
end
endmodule