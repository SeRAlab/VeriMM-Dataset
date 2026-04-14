module top_module(raAddress, rbAddress,
		    regA, regB, regWrite,
		    dataIn, reset, clk);input [1:0] raAddress, rbAddress;
   input [7:0] dataIn;
   input       regWrite, reset, clk;

   
   output [7:0] regA, regB;

   
   reg [7:0] 	registerMemory [3:0];

   assign regA = registerMemory[raAddress];
   assign regB = registerMemory[rbAddress];
   
   always @(negedge clk) begin
      if (regWrite)
	registerMemory[raAddress] = dataIn;
   end

   always @(reset) begin
      if (reset) begin
	 registerMemory[0] = 0;
	 registerMemory[1] = 0;
	 registerMemory[2] = 0;
	 registerMemory[3] = 0;
      end
   end

endmodule