module top_module(

	input [63:0] ic_iq_pc,
	input [63:0] ic_iq_instr,

	output [63:0] align_instr,
	output [3:0] align_instr_mask

);wire [2:0] pc_lsb = ic_iq_pc[2:0];


	assign align_instr = 
			( {64{pc_lsb == 3'b000}} & ic_iq_instr)
			|
			( {64{pc_lsb == 3'b010}} & {16'b0, ic_iq_instr[63:16]} )
			|
			( {64{pc_lsb == 3'b100}} & {32'b0, ic_iq_instr[63:32]})
			|
			( {64{pc_lsb == 3'b110}} & {48'b0, ic_iq_instr[63:48]});

	assign align_instr_mask = 
			( {4{pc_lsb == 3'b000}} & 4'b1111)
			|
			( {4{pc_lsb == 3'b010}} & 4'b0111 )
			|
			( {4{pc_lsb == 3'b100}} & 4'b0011)
			|
			( {4{pc_lsb == 3'b110}} & 4'b0001);





endmodule