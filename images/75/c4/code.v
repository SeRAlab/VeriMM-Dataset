module top_module(i_wreg,i_m2reg,i_mo,i_alu,i_rn,clk,rst,o_wreg,o_m2reg,o_mo,o_alu,o_rn);input wire clk, rst,i_wreg,i_m2reg;
  input wire [31:0] i_mo,i_alu;
  input wire [4:0] i_rn;
  output reg o_wreg,o_m2reg;
  output reg [31:0] o_mo,o_alu;
  output reg [4:0] o_rn;
  always @(posedge clk) begin
  if (rst) begin 
	o_wreg<=0;
	o_m2reg<=0;
	o_alu<=0;
	o_mo<=0;
	o_rn<=0;
	end

  else begin 
	o_wreg<=i_wreg;
	o_m2reg<=i_m2reg;
	o_alu<=i_alu;
	o_mo<=i_mo;
	o_rn<=i_rn;
	end

  end
endmodule