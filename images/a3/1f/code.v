module top_module(IWB,IDataMemory,IAlu,IInstruction,OWB,ODataMemory,OAlu,OInstruction,Clk);input[1:0] IWB;
	input [63:0] IDataMemory;
	input [63:0] IAlu;
	input [4:0] IInstruction;
	input Clk;

	output reg OWB;
	output reg [63:0]ODataMemory;
	output reg [63:0] OAlu;
	output reg [4:0] OInstruction;

	reg [134:0] registers;


	always @(posedge Clk)
	begin 	
		ODataMemory = registers[63:0];
		OWB = registers[65:64];
		OAlu = registers[129:66];
		OInstruction = registers[134:130];

		registers[63:0]=IDataMemory;
		registers[65:64] = IWB;
		registers[129:66] = IAlu;
	        registers[134:130] =IInstruction;
	end
endmodule