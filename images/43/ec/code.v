module top_module(	
				input 		 IDL,
				input [7:0] 	 data_in0,
				input 		 valid0,
				input [7:0] 	 data_in1,
				input 		 valid1,
				input [7:0] 	 data_in2,
				input 		 valid2,
				input [7:0] 	 data_in3,
				input 		 valid3,
				output reg [7:0] L1_in0,
				output reg 	 L1_valid0,
				output reg [7:0] L1_in1,
				output reg 	 L1_valid1,
				output reg [7:0] L1_in2,
				output reg 	 L1_valid2,
				output reg [7:0] L1_in3,
				output reg 	 L1_valid3
				);always @(*) begin
      if (IDL == 0) begin
	 L1_in0 = 0;
	 L1_valid0 = 0;
	 L1_in1 = 0;
	 L1_valid1 = 0;
	 L1_in2 = 0;
	 L1_valid2 = 0;
	 L1_in3 = 0;
	 L1_valid3 = 0;
      end
      else begin
	 L1_in0 = data_in0;
	 L1_valid0 = valid0;
	 L1_in1 = data_in1;
	 L1_valid1 = valid1;
	 L1_in2 = data_in2;
	 L1_valid2 = valid2;
	 L1_in3 = data_in3;
	 L1_valid3 = valid3;
      end
   end
endmodule