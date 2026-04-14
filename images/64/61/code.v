module top_module(ALUCtrl , ALUop, FuncCode ) ;input [3 : 0] ALUop;
input [5 : 0] FuncCode ;
output reg [3:0] ALUCtrl;


always@(*) begin
if(ALUop==4'b1111) begin 
	case(FuncCode)
		6'b000000: ALUCtrl=4'b0011; 
		6'b000010: ALUCtrl=4'b0100; 
		6'b100000: ALUCtrl=4'b0010; 
		6'b100010: ALUCtrl=4'b0110; 
		6'b100100: ALUCtrl=4'b0000; 
		6'b100101: ALUCtrl=4'b0001; 
		6'b101010: ALUCtrl=4'b0111; 
		
		6'b111000: ALUCtrl=4'b0101; 
		6'b101011: ALUCtrl=4'b1011; 
		6'b100111: ALUCtrl=4'b1100; 
		6'b100110: ALUCtrl=4'b1010; 
		6'b100011: ALUCtrl=4'b1001; 
		6'b100001: ALUCtrl=4'b1000; 
		6'b000011: ALUCtrl=4'b1101; 
	endcase
end
else begin
	ALUCtrl=ALUop; 
	end
end
endmodule