module top_module(input[4:0] in, input clk, rst, writeData, output[4:0] out);reg [4:0] outData;
	assign out = outData;
	always@(posedge clk, posedge rst)begin
		if(rst) outData <= 5'b0;
		else
		begin
			if(writeData) outData <= in;
			else outData <= outData;
		end
	end
endmodule