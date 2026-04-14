module top_module(
	(*mark_debug="true"*)input                   s_axis_aclk     ,
	(*mark_debug="true"*)input                   s_axis_tlast    ,
	(*mark_debug="true"*)input                   s_axis_tuser    ,
	(*mark_debug="true"*)input[11:0]			 img_vsize		 ,
	(*mark_debug="true"*)output                  FrmCmp_Irq      
		
);(*mark_debug="true"*)reg[11:0] vsize_cnt = 12'd0;
(*mark_debug="true"*)reg tuser_dly;
(*mark_debug="true"*)reg tlast_dly;
(*mark_debug="true"*)reg FrmCmp_reg;

assign FrmCmp_Irq = (vsize_cnt == img_vsize)?  1'b1: 1'b0;

always@(posedge s_axis_aclk)
begin
	tuser_dly <= s_axis_tuser;
	tlast_dly <= s_axis_tlast;
end


always@(posedge s_axis_aclk)
begin
	if((~tuser_dly) & s_axis_tuser)
	begin
		vsize_cnt <= 12'd0;
	end
	else
	begin
		if(vsize_cnt < img_vsize)
		begin
			if((~tlast_dly) & s_axis_tlast)
			begin
				vsize_cnt <= vsize_cnt + 1'b1;
			end	
		end
	end
	
end


endmodule