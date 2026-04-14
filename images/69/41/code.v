module top_module(clk,Rtin,Rdin,PCplusin,rdatain,ALUresultin,RegDstin,RegWrin,MemtoRegin,
Rtout,Rdout,PCplusout,rdataout,ALUresultout,RegDstout,RegWrout,MemtoRegout);input clk;
input [4:0] Rtin;
input [4:0] Rdin;
input [31:0] PCplusin;
input [31:0] rdatain;
input [31:0] ALUresultin;
input [1:0] RegDstin;
input RegWrin;
input [1:0] MemtoRegin;
output [4:0] Rtout;
reg [4:0] Rtout;
output [4:0] Rdout;
reg [4:0] Rdout;
output [31:0] PCplusout;
reg [31:0] PCplusout;
output [31:0] rdataout;
reg [31:0] rdataout;
output [31:0] ALUresultout;
reg [31:0] ALUresultout;
output [1:0] RegDstout;
reg [1:0] RegDstout;
output RegWrout;
reg RegWrout;
output [1:0] MemtoRegout;
reg [1:0] MemtoRegout;

always @(posedge clk)
begin
  Rtout <= Rtin;
  Rdout <= Rdin;
  PCplusout <= PCplusin;
  rdataout <= rdatain;
  ALUresultout <= ALUresultin;
  RegDstout <= RegDstin;
  RegWrout <= RegWrin;
  MemtoRegout <= MemtoRegin;
end

endmodule