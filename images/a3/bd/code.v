module top_module(clk,branch,PCSrc,IRQin,datahazard,instructionin,PCplusin,instructionout,PCplusout,IRQout);input clk;
input branch;
input datahazard;
input [2:0] PCSrc;
input IRQin;
input [31:0] instructionin;
input [31:0] PCplusin;
output [31:0] instructionout;
output [31:0] PCplusout;
output IRQout;

reg [31:0] instruction;
reg [31:0] PCplus;
reg IRQ;

always @(posedge clk)
begin
  if(PCSrc == 3'b000)
  begin
    if(~datahazard)
    begin
      instruction <= instructionin;
      PCplus <= PCplusin;
      IRQ <= IRQin;
    end
    else;
  end
  else
  begin
    if(PCSrc == 3'b001 && branch == 1'b0)
    begin
      instruction <= instructionin; 
      PCplus <= PCplusin;
      IRQ <= IRQin;
    end
    else
    begin
      instruction <= 32'h0;  
      IRQ <=  IRQin;
    end
  end
end

assign instructionout = instruction;
assign PCplusout = PCplus;
assign IRQout =  IRQ;

endmodule