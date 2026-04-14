module top_module(Clk,WriteEn,Raddr,Waddr,DataIn,DataOutA,DataOutB);parameter W=8, D=3;  
	input        Clk,
				 WriteEn;
	input        [D-1:0] Raddr,				  
				 Waddr;
	input        [W-1:0] DataIn;
	output reg   [W-1:0] DataOutA;	
	output reg   [W-1:0] DataOutB;				


reg [W-1:0] Registers[(2**D)-1:0];	  






always@*
begin
 DataOutA = Registers[0];	  
 DataOutB = Registers[Raddr];    
end


always @ (posedge Clk)
  if (WriteEn)	                             
    Registers[Waddr] <= DataIn;
endmodule