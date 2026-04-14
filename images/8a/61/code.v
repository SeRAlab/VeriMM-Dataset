module top_module(instruction, RFRD2, WriteReg, MovK, MemMov);input [31:0] instruction;
input [63:0] RFRD2, MemMov;
input MovK;

output reg [63:0] WriteReg;

always@(instruction, MovK, MemMov, RFRD2)
begin

if (MovK==1)
    WriteReg={RFRD2[63:16], instruction[20:5]};
else if (MovK==0)
    WriteReg=MemMov;

end

endmodule