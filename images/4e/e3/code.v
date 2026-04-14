module top_module(clock,reset,instruction,read_data1,read_data2,dataRFOut1,dataRFOut2,instructionPropagation, ID_EX_op1, ID_EX_op2, opDestino);input clock, reset;
  	input [19:0] instruction;
	input [19:0] read_data1;  
	input [19:0] read_data2;  
	
	output reg [19:0] dataRFOut1; 
	output reg [19:0] dataRFOut2;
	output reg [19:0] instructionPropagation;
	output reg [3:0] ID_EX_op1, ID_EX_op2, opDestino;
	
	always @(posedge clock) begin
		if (reset) begin
			dataRFOut1 <= 20'b0;
			dataRFOut2 <= 20'b0;
			
		end else begin
			dataRFOut1 <= read_data1;
			dataRFOut2 <= read_data2;
			instructionPropagation <= instruction;
			ID_EX_op1 <= instruction[11:8];
			ID_EX_op2 <= instruction[7:4];
			opDestino <= instruction[15:12];
		end
	end
endmodule