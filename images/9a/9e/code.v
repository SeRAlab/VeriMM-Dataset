module top_module(clk,reset,datahazard,PCSrc,ALUOut,ConBA,JT,DatabusA,PC,PCplusout);input clk;
input reset;
input datahazard;
input [2:0] PCSrc;
input ALUOut;
input [31:0] ConBA;
input [25:0] JT;
input [31:0] DatabusA;
output [31:0] PC;
output [31:0] PCplusout;

reg [31:0] currentPC;

always @(posedge clk or negedge reset)
begin
  if(~reset) currentPC <= 32'h80000000;
  else
  begin
    if(~datahazard)
    begin
      case(PCSrc[2:0])
        3'b000: currentPC <= PCplusout;
        3'b001: currentPC <= (ALUOut == 1'b0) ? PCplusout : {currentPC[31],ConBA[30:0]};
        3'b010: currentPC <= {currentPC[31],3'b000,JT,2'b00};
        3'b011: currentPC <= DatabusA;
        3'b100: currentPC <= 32'h80000004;
        default: currentPC <= 32'h80000008;
      endcase
    end
    else;
  end
end

assign PC = currentPC;
assign PCplusout = {PC[31],PC[30:0] + 31'h00000004};
 
endmodule