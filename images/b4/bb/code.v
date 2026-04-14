module top_module(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);input [63:0] CurrentPC, SignExtImm64; 
      	input Branch, ALUZero, Uncondbranch; 
      	output reg [63:0] NextPC; 
      	

  		always@ (Uncondbranch or Branch or ALUZero or SignExtImm64 or CurrentPC)	
        begin
          if(Uncondbranch | (Branch & ALUZero))										
           	NextPC = #3 (SignExtImm64 << 2) + CurrentPC;							
          else
           	NextPC = #2 CurrentPC + 4;												
        end
endmodule