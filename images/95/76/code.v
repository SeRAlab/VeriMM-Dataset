module top_module(
		input [2:0] rSrc,
		input [2:0] rDest,
		input write_reg,
		input [7:0] writeData,
		input reset,
		output reg [7:0] srcData
    );reg [7:0] registers [7:0];
	 integer i;
	 
	 always @ (reset)
	 begin
	if (reset == 1)
	begin
		for(i=0; i<8; i=i+1)
	begin
		if (i %2 == 0)
			registers[i] = 8'b01010101;
		else
			registers[i] = 8'b00001010;
	end
	end
	
	 end
	 
	 always @ (*)
	 begin
	 
	 srcData = registers[rSrc];
	 
    if (write_reg == 1)
		registers[rDest] = writeData;
	 end


endmodule