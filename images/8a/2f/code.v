module top_module(flushIDEX,RegDstin,RegWrin,ALUSrc1in,ALUSrc2in,ALUFunin,Signin,MemWrin,MemRdin,MemtoRegin,
RegDstout,RegWrout,ALUSrc1out,ALUSrc2out,ALUFunout,Signout,MemWrout,MemRdout,MemtoRegout);input flushIDEX;
input [1:0] RegDstin;
input RegWrin;
input ALUSrc1in;
input ALUSrc2in;
input [5:0] ALUFunin;
input Signin;
input MemWrin;
input MemRdin;
input [1:0] MemtoRegin;
output [1:0] RegDstout;
reg [1:0] RegDstout;
output RegWrout;
reg RegWrout;
output ALUSrc1out;
reg ALUSrc1out;
output ALUSrc2out;
reg ALUSrc2out;
output [5:0] ALUFunout;
reg [5:0] ALUFunout;
output Signout;
reg Signout;
output MemWrout;
reg MemWrout;
output MemRdout;
reg MemRdout;
output [1:0] MemtoRegout;
reg [1:0] MemtoRegout;

always @(*)
begin
  if(~flushIDEX)
  begin
    RegDstout <= RegDstin;
    RegWrout <= RegWrin;
    ALUSrc1out <= ALUSrc1in;
    ALUSrc2out <= ALUSrc2in;
    ALUFunout <= ALUFunin;
    Signout <= Signin;
    MemWrout <= MemWrin;
    MemRdout <= MemRdin;
    MemtoRegout <= MemtoRegin;
  end
  else
  begin
    RegDstout <= 2'b00;
    RegWrout <= 0;
    ALUSrc1out <= 0;
    ALUSrc2out <= 0;
    ALUFunout <= 6'h0;
    Signout <= 0;
    MemWrout <= 0;
    MemRdout <= 0;
    MemtoRegout <= 2'b00;
  end
end

endmodule