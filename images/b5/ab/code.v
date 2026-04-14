module top_module(
CLK, 
RST, 
ENA, 
BITVAL, 
CRC);input CLK; 
input RST;   
input ENA; 
input BITVAL; 
output reg [6:0] CRC; 

   
 
wire inv;
   
assign inv = BITVAL ^ CRC[6]; 
   
always @(negedge CLK) 
begin
	if (RST) 
	begin
		CRC = {16{1'b0}};
	end
	else 
	begin
		if (ENA)
		begin
				CRC[6] = CRC[5];
				CRC[5] = CRC[4];
				CRC[4] = CRC[3];
				CRC[3] = CRC[2] ^ inv;
				CRC[2] = CRC[1];
				CRC[1] = CRC[0];
				CRC[0] = inv;
		end
	end
end
endmodule