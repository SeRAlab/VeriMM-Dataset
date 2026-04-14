module top_module(
	input [31:0]addr,
	input [31:0]DMEM,
	input [31:0]Random,
	input [31:0]Switch,
	input [31:0]Timer,
	input [31:0]EthNew,
	input [31:0]EthData1,
	input [31:0]EthData2,
	input [31:0]EthSendFinish,
	output reg[31:0]rdata
);always @(*) begin
		if(addr[11] == 1'b1) begin
			
			case(addr[11:0])
				12'h808: rdata = Random;
				12'h80c: rdata = Switch;
				12'h814: rdata = Timer;
				12'h820: rdata = EthNew;
				12'h824: rdata = EthData1;
				12'h828: rdata = EthData2;
				12'h834: rdata = EthSendFinish;
				default: rdata = DMEM;
			endcase
		end else begin
			
			rdata = DMEM;
		end
	end
endmodule