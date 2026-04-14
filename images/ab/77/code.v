module top_module(
    rst,
    clk,
    i_adr1,
    i_adr2,
    i_adr3,
    i_wreg,
    i_wdata,
    i_wen,
    o_op1,
    o_op2,
    o_op3
);input clk;
	 input rst;                
	 input [4:0] i_adr1; 
	 input [4:0] i_adr2;
	 input [4:0] i_adr3;
	 input [31:0] i_wdata;
	 input [4:0] i_wreg;
	 input i_wen;
	 output [31:0] o_op1;
	 output [31:0] o_op2;
	 output [31:0] o_op3;
	 reg [31:0] mem[31:0];
	 
		assign o_op1 = i_adr1==0 ? 0 : mem[i_adr1];
		assign o_op2 = i_adr2==0 ? 0 : mem[i_adr2];
		assign o_op3 = i_adr3==0 ? 0 : mem[i_adr3];
	 always @(posedge clk or posedge rst) begin
		if (rst == 1) begin
			  mem[0] <= 32'h00000000;
			  mem[1] <= 32'h00000000;
			  mem[2] <= 32'h00000000;
			  mem[3] <= 32'h00000000;
			  mem[4] <= 32'h00000000;
		end
		else if (i_wen) begin
			mem[i_wreg] <= (i_wreg == 5'b00000) ? 32'h00000000 : i_wdata;
		end
	 end
endmodule