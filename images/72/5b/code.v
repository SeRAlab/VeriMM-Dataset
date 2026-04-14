module top_module(input [5:0] imemout, output reg brnch, output reg memorywrite, output reg memoryread, output reg alusrc, output reg regw, output reg regdst, output reg aluop, output reg memtoreg);always @ ( imemout )
begin
	if(imemout == 6'b000000)
	begin
		brnch = 1'b0;
		memorywrite = 1'b0;
		memoryread = 1'b0;
		alusrc = 1'b0;
		regw = 1'b1;
		regdst = 1'b1;
		aluop = 1'b1;
		memtoreg = 1'b1;
	end
	else if(imemout == 6'b100011)
	begin
		brnch = 1'b0;
		memorywrite = 1'b0;
		memoryread = 1'b1;
		alusrc = 1'b1;
		regw = 1'b1;
		regdst = 1'b0;
		aluop = 1'b0;
		memtoreg = 1'b0;
	end
	else if(imemout == 6'b101011)
	begin
		brnch = 1'b0;
		memorywrite = 1'b1;
		memoryread = 1'b0;
		alusrc = 1'b1;
		regw = 1'b0;
		regdst = 1'b0;
		aluop = 1'b0;
		memtoreg = 1'b0;
	end
	else if(imemout == 6'b000100)
	begin
		brnch = 1'b1;
		memorywrite = 1'b0;
		memoryread = 1'b0;
		alusrc = 1'b0;
		regw = 1'b0;
		regdst = 1'b0;
		aluop = 1'b0;
		memtoreg = 1'b0;
	end
	else
	begin
		brnch = 1'b0;
		memorywrite = 1'b0;
		memoryread = 1'b0;
		alusrc = 1'b0;
		regw = 1'b0;
		regdst = 1'b0;
		aluop = 1'b0;
		memtoreg = 1'b0;
	end
end

endmodule