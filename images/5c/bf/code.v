module top_module(regA, regB, Wdat,regW, RegWrite, clk, resetn, Adat, Bdat,regTEST,TESTdat);input clk,RegWrite,resetn;		
    input [4:0] regA, regB, regW,regTEST;	
    input [31:0] Wdat;			
    output wire [31:0] Adat, Bdat,TESTdat;		
	 reg [31:0] regfile [0:31];
	 reg [5:0] i;
	 assign  Adat=regfile[regA];
	 assign  Bdat=regfile[regB];
	 assign  TESTdat=regfile[regTEST];

	 always @(posedge clk) begin
        
		  if (~resetn) for (i=0;i<32;i=i+1) regfile[i]=0; else
		if(RegWrite) regfile[regW]=(regW==0)?32'b0:Wdat;
	end
endmodule