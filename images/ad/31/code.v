module top_module(readData2, signExtend, sinalDoControleMux3, saidaMux3);input [31:0] readData2;
input [31:0] signExtend;
input [0:0] sinalDoControleMux3;

wire [31:0] readData2, signExtend;
wire [0:0] sinalDoControleMux3;


output [31:0] saidaMux3;
wire [31:0] saidaMux3;


assign saidaMux3 [31:0] = sinalDoControleMux3==0 ? readData2 : signExtend;


	
		
		
	
endmodule