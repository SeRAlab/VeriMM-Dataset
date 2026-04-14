module top_module(
	
	input		de_clk,		
	input		de_rstn,	
	input		ee_s0_hit,	
	input		ee_s1_hit,	
	input		eo_s0_hit,	
	input		eo_s1_hit,	
	input		oe_s0_hit,	
	input		oe_s1_hit,	
	input		oo_s0_hit,	
	input		oo_s1_hit,	
	input	[4:0]	ee_tag_adr_wr,	
	input	[4:0]	eo_tag_adr_wr,	
	input	[4:0]	oe_tag_adr_wr,	
	input	[4:0]	oo_tag_adr_wr,	
	input	[4:0]	ee_tag_adr_rd,	
	input	[4:0]	eo_tag_adr_rd,	
	input	[4:0]	oe_tag_adr_rd,	
	input	[4:0]	oo_tag_adr_rd,	
	
	output		ee_lru,		
	output		eo_lru,		
	output		oe_lru,		
	output		oo_lru		
	);reg	[31:0]	ee_set_reg;	
reg	[31:0]	eo_set_reg;	
reg	[31:0]	oe_set_reg;	
reg	[31:0]	oo_set_reg;	

assign ee_lru = ee_set_reg[ee_tag_adr_rd];
assign eo_lru = eo_set_reg[eo_tag_adr_rd];
assign oe_lru = oe_set_reg[oe_tag_adr_rd];
assign oo_lru = oo_set_reg[oo_tag_adr_rd];

wire	[31:0]	sel_ee;
wire	[31:0]	sel_eo;
wire	[31:0]	sel_oe;
wire	[31:0]	sel_oo;

assign sel_ee = 32'b1 << (ee_tag_adr_wr);
assign sel_eo = 32'b1 << (eo_tag_adr_wr);
assign sel_oe = 32'b1 << (oe_tag_adr_wr);
assign sel_oo = 32'b1 << (oo_tag_adr_wr);


always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)ee_set_reg <= 0;
		else if(ee_s0_hit)ee_set_reg <= ee_set_reg | sel_ee;
		else if(ee_s1_hit)ee_set_reg <= ee_set_reg & ~sel_ee;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)eo_set_reg <= 0;
		else if(eo_s0_hit)eo_set_reg <= eo_set_reg | sel_eo;
		else if(eo_s1_hit)eo_set_reg <= eo_set_reg & ~sel_eo;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oe_set_reg <= 0;
		else if(oe_s0_hit)oe_set_reg <= oe_set_reg | sel_oe;
		else if(oe_s1_hit)oe_set_reg <= oe_set_reg & ~sel_oe;
	end
always @(posedge de_clk or negedge de_rstn)
	begin
		if(!de_rstn)oo_set_reg <= 0;
		else if(oo_s0_hit)oo_set_reg <= oo_set_reg | sel_oo;
		else if(oo_s1_hit)oo_set_reg <= oo_set_reg & ~sel_oo;
	end

endmodule