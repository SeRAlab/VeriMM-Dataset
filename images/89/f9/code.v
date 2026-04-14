module top_module(
	input mem_read_IDEX_i,
	input reset,
	input clk,
	input branch_i,
	input jmp_i,
	input topc_i,
	input [4:0] Rt_IDEX_i,
	input [4:0] Rt_IFID_i,
	input [4:0] Rs_IFID_i,
	
	output PC_disenabler_o,
	output IFID_disenabler_o,
	output control_zero_mux_o,
	
	output flush_o
);reg [3:0] control_hazard_r = 4'b0000;

always@(mem_read_IDEX_i,Rt_IDEX_i,Rt_IFID_i,Rs_IFID_i,branch_i,jmp_i,topc_i) begin

	if((branch_i == 1)||(jmp_i == 1)||(topc_i == 1))
		control_hazard_r = 4'b0001;
	else if(mem_read_IDEX_i == 1 && (Rt_IDEX_i == Rt_IFID_i ||  Rt_IDEX_i == Rs_IFID_i) )
		control_hazard_r = 4'b1110;
	else
		control_hazard_r = 4'b0000;

end

assign control_zero_mux_o = control_hazard_r[3];
assign IFID_disenabler_o = control_hazard_r[2];
assign PC_disenabler_o = control_hazard_r[1];
assign flush_o = control_hazard_r[0];

endmodule