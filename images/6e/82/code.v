module top_module(
	rs,rt,op,func,
	id_td, id_LW,
	stall
    );input wire [4:0] rs, rt;
	input wire [5:0] op, func;
	input wire [4:0] id_td;
	input wire id_LW;
	output wire stall;
	
	wire rs_cnt, rt_cnt;

	wire r_type, s_type, i_sll, i_srl, i_sra;	
	wire i_addi,i_andi,i_ori,i_xori,i_slti,i_type,i_lw,i_sw;
	wire i_beq,i_bgez,i_bgtz,i_blez,i_bltz,i_bne;
	
	
	and(r_type,~op[5],~op[4],~op[3],~op[2],~op[1],~op[0]);

	
	or(s_type,i_sll, i_srl, i_sra);
	and(i_sll, r_type, ~func[5], ~func[4], ~func[3], ~func[2], ~func[1], ~func[0]);	
	and(i_srl, r_type, ~func[5], ~func[4], ~func[3], ~func[2], func[1], ~func[0]);	
	and(i_sra, r_type, ~func[5], ~func[4], ~func[3], ~func[2], func[1], func[0]);	
	

	
	or(i_type, i_addi, i_andi, i_ori, i_xori, i_slti, b_type, i_lw, i_sw );
	and(i_addi,~op[5],~op[4], op[3],~op[2],~op[1],~op[0]);	
	and(i_andi,~op[5],~op[4], op[3], op[2],~op[1],~op[0]);	
	and(i_ori, ~op[5],~op[4], op[3], op[2],~op[1], op[0]);
	and(i_xori,~op[5],~op[4], op[3], op[2], op[1],~op[0]);
	and(i_slti,~op[5],~op[4], op[3], ~op[2], op[1],~op[0]);
	and(i_lw, op[5],~op[4],~op[3],~op[2], op[1], op[0]);
	and(i_sw, op[5],~op[4], op[3],~op[2], op[1], op[0]);
	
	or(b_type, i_beq, i_bgez, i_bgtz, i_blez, i_bltz, i_bne);
	and(i_beq, ~op[5],~op[4],~op[3], op[2],~op[1],~op[0]);	
	and(i_bgez,~op[5],~op[4],~op[3], ~op[2],~op[1],op[0]);	
	and(i_bgtz,~op[5],~op[4],~op[3], op[2],op[1],op[0]);	
	and(i_blez,~op[5],~op[4],~op[3], op[2],op[1],~op[0]);	
	and(i_bltz,~op[5],~op[4],op[3], ~op[2],~op[1],op[0]);	
	and(i_bne, ~op[5],~op[4],~op[3], op[2],~op[1], op[0]);	
	
	


	
	assign rs_cnt = (r_type & ~s_type) | i_type;
	assign rt_cnt = r_type | i_sw | b_type;
	assign stall = id_LW & (((rs==id_td) & rs_cnt) | ((rt==id_td) & rt_cnt));

endmodule