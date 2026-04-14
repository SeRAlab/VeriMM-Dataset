module top_module( 
  input clk, rst,
  input[3:0] src1, src2, dest_wb, 
  input[31:0] result_wb, 
  input write_back_enable,
  output reg [31:0] reg1, reg2,
  output [31:0] R0,R1,R2,R3,R4,R5,R6,R7,R8,R9,R10,R11
);reg[31:0] regs[15:0];
  assign R0 = regs[0];
  assign R1 = regs[1];
  assign R2 = regs[2];
  assign R3 = regs[3];
  assign R4 = regs[4];
  assign R5 = regs[5];
  assign R6 = regs[6];
  assign R7 = regs[7];
  assign R8 = regs[8];
  assign R9 = regs[9];
  assign R10 = regs[10];
  assign R11 = regs[11];

    always @(src1, src2, regs[src1], regs[src2]) begin
      reg1 <= regs[src1];
      reg2 <= regs[src2];
    end
  
  integer i;
	always @(negedge clk, posedge rst) begin
		if (rst) begin
			for (i = 0; i < 16; i = i + 1) begin
				regs[i] <= i;
			end
		end
		else if (write_back_enable) begin 
			regs[dest_wb] <= result_wb;
		end
	end

endmodule