module top_module( newSP , SP, CE, PRESET, CLK);input [15:0] newSP;
    input CE;
    input PRESET;
    input CLK;
    output reg [15:0] SP;
	 
	 always @(posedge CLK ) begin
		if (PRESET == 1) 
			SP <= 16'hf3ff;
		else if (CE == 1)
			SP <= newSP;
	 end
	 

endmodule