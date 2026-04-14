module top_module(clk, instruction, opCode, rs, rt, rd, address,funct,shamt);input clk;
input [31:0] instruction ;
output  [5:0] opCode;
output reg [4:0] rs;
output reg [4:0] rt;
output reg [4:0] rd;
output reg [5:0] funct;
output reg [15:0] address;
output reg [4:0] shamt;



  assign opCode  = instruction[31:26];

always @(instruction) begin
if (opCode==6'b000000) begin
  rs = instruction[25:21];
  rd = instruction[20:16];
  rt = instruction[15:11];
  funct = instruction[5:0];
  shamt = instruction[10:6];

end
else
begin
    rs = instruction[25:21];
    rt = instruction[20:16];
    address = instruction[15:0];

end
end
endmodule