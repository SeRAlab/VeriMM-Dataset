module top_module(
	clk,
	rst,
	ALUout,
	XM_RD,
	XM_MemToReg,
	XM_RT,
	XM_MemWrite,
	bnoWB,
	en,
	
	MW_ALUout,
	MW_RD
);input clk, rst,en;
input [31:0] ALUout,XM_RT;
input [4:0] XM_RD;
input XM_MemToReg,XM_MemWrite,bnoWB;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;


reg [31:0] DM [0:127];


always @(posedge clk)
  if(XM_MemWrite && en)
    DM[ALUout] <= XM_RT;	


always @(posedge clk )
begin

  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;
	end
  else if(XM_MemToReg && en)
    begin
	  MW_ALUout <= DM[ALUout];
	  MW_RD		<=(bnoWB)?5'd0:XM_RD;
	end
  else if(en)
    begin
	  MW_ALUout	<=	ALUout;
	  MW_RD		<=(bnoWB)?5'd0:XM_RD;
	end

end

endmodule