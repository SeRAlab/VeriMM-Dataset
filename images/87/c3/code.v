module top_module(CLK,RST,ED,START,DReal,DImag,RDY,DOReal,DOImag);parameter total_bits = 32;
input  CLK;
input  RST;
input  ED;
input  START;
input  [total_bits-1:0] DReal;
input  [total_bits-1:0] DImag;
output reg RDY;
output [total_bits-1:0] DOReal;
output [total_bits-1:0] DOImag;


reg    [total_bits-1:0] DATAReal [0:31];
reg    [total_bits-1:0] DATAImag [0:31];

reg [5:0] addr;
reg [6:0] count;
reg delay;

reg flag;
	always @(posedge CLK)
		begin
			if (RST) begin
					addr<=6'b000000;
					count<= 7'b0000000;
					flag<=0;
					delay<=0;
				RDY<=1'b0; end
			else if (START) begin 
					addr<=6'b000000;
					count<= 7'b0000000;
					flag<=0;
					delay<=0;
				RDY<=1'b0;end
			else if (ED)	begin
				RDY<=1'b0;
					if(count<=31)
					begin
						DATAReal[{addr[0],addr[4:1]}] <= DReal;
						DATAImag[{addr[0],addr[4:1]}] <= DImag;
					end
					 
					if (count!=127)                                
					count<=count+1;
					if (count==31||count==126)							
					begin
					 RDY<=1'b1;
					 delay<=1'b1;
					 if(flag == 0) begin addr<=0; flag<=1; end
					 else addr<=16;
					end	
					else
						if(delay)
							delay<=0;
						else
							addr<=addr+1;
			end 
		end
	assign DOReal = DATAReal[addr[4:0]];
   assign DOImag = DATAImag[addr[4:0]];	
		 
endmodule