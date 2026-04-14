module top_module(
input [3:0] ALUop,
input [31:0] OpA, OpB,
output wire [31:0] ALUResult,
output Zero
);reg [31:0] temp;
reg ZeroFlag;

assign ALUResult = temp;
assign Zero = ZeroFlag; 

always @(*) begin
case (ALUop)
	4'b0010: begin
		temp = OpA + OpB;
		ZeroFlag = 0;
		end
	4'b0110: begin
		temp = OpA - OpB;
		if(temp == 0) 
			ZeroFlag = 1; 
		else
			ZeroFlag = 0; 
		end
	4'b1000: begin
		temp = OpA * OpB;
		ZeroFlag = 0;
		end
	4'b0000: begin 
		temp = OpA & OpB; 
		ZeroFlag = 0;
		end
	4'b0001: begin 
		temp = OpA | OpB; 
		ZeroFlag = 0;
		end	
	4'b1101: begin 
		temp = OpA ^ OpB; 
		ZeroFlag = 0;
		end	
	4'b1100: begin 
		temp = ~(OpA | OpB); 
		ZeroFlag = 0;
		end
endcase
end
endmodule