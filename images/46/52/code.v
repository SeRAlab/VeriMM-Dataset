module top_module(
   input  clock,
   input  reset,
   input  [4:0]  ReadReg1, ReadReg2, WriteReg,
   input  [31:0] WriteData,
   input  RegWrite,
   output [31:0] ReadData1, ReadData2,
	
	input	 [991:0] registers_in,
	output [991:0] registers_out
   );wire [31:0] registers [1:31];
	reg [31:0] vote_registers [1:31];

   
   
   integer i;
		always @(posedge clock) begin
		for (i=1; i<32; i=i+1) begin
			vote_registers[i] <= (reset) ? 0 : (RegWrite && (WriteReg==i)) ? WriteData : registers[i];
		end
   end

	genvar j;
	generate
		for (j=1; j<32; j=j+1) begin : Voter_Signals
			assign registers[j] = registers_in[((32*j)-1):(32*(j-1))];
			assign registers_out[((32*j)-1):(32*(j-1))] = vote_registers[j];
		end
	endgenerate

   
   assign ReadData1 = (ReadReg1 == 0) ? 32'h00000000 : registers[ReadReg1];
   assign ReadData2 = (ReadReg2 == 0) ? 32'h00000000 : registers[ReadReg2];

endmodule