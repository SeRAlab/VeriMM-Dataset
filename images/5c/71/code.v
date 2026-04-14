module top_module(RD, A);output  [31:0]  RD;
	input   [31:0]  A;

	reg     [31:0]  RD;

	
	always @(A) begin
		case(A[5:2])
			4'b0000: RD = 32'hE202_2000;  
			4'b0001: RD = 32'hE382_3000;  
			4'b0010: RD = 32'hE383_4005;  
			4'b0011: RD = 32'hE034_4004;  
			4'b0100: RD = 32'hEA00_0005;  
			4'b0101: RD = 32'hE082_2004;  
			4'b0110: RD = 32'hE254_4001;  
			4'b0111: RD = 32'hE154_0003;  
			4'b1000: RD = 32'h1AFF_FFFB;  
			4'b1001: RD = 32'hE583_2000;  
			4'b1010: RD = 32'hE593_5000;  
			4'b1011: RD = 32'hEAFF_FFFE;  
			default: RD = 32'hEAFF_FFFE;  
		endcase
	end
endmodule