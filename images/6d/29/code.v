module top_module(
     input [31:0]roadc5,
	 input [31:0]resc3,
	 input Mtoreg,
	 output reg [31:0]sWritedata
	 
);always @*
case (Mtoreg) 
      1:
	     sWritedata <= roadc5;
	  0:
	     sWritedata <= resc3;
endcase
endmodule