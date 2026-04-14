module top_module(clk,rst,wea,r1,r2,r3,w1,wdata,out1,out2,out3
    );input wire clk,rst,wea;
	input wire [4:0] r1, r2,r3, w1;
	input wire [31:0] wdata;
	output wire [31:0] out1, out2, out3;

	reg [31:0] mem [31:0];
	
	always @(posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				mem[0] <=32'b0;mem[1] <=32'b0;mem[2] <=32'b0;mem[3] <=32'b0;
				mem[4] <=32'b0;mem[5] <=32'b0;mem[6] <=32'b0;mem[7] <=32'b0;
				mem[8] <=32'b0;mem[9] <=32'b0;mem[10]<=32'b0;mem[11]<=32'b0;
				mem[12]<=32'b0;mem[13]<=32'b0;mem[14]<=32'b0;mem[15]<=32'b0;
				mem[16]<=32'b0;mem[17]<=32'b0;mem[18]<=32'b0;mem[19]<=32'b0;
				mem[20]<=32'b0;mem[21]<=32'b0;mem[22]<=32'b0;mem[23]<=32'b0;
				mem[24]<=32'b0;mem[25]<=32'b0;mem[26]<=32'b0;mem[27]<=32'b0;
				mem[28]<=32'b0;mem[29]<=32'b0;mem[30]<=32'b0;mem[31]<=32'b0;
				
			end
		else if(wea)
			mem[w1]<=wdata;
			
	end
	
	assign o_op1=mem[r1];
	assign o_op2=mem[r2];
	assign o_op3=mem[r3];

endmodule