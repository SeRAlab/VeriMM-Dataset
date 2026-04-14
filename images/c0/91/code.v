module sparc_mul_cntl(
  ecl_mul_req_vld,
  spu_mul_req_vld,
  spu_mul_acc,
  spu_mul_areg_shf,
  spu_mul_areg_rst,
  spu_mul_mulres_lshft,
  c0_act,
  spick,
  byp_sel,
  byp_imm,
  acc_imm,
  acc_actc2,
  acc_actc3,
  acc_actc5,
  acc_reg_enb,
  acc_reg_rst,
  acc_reg_shf,
  x2,
  mul_ecl_ack,
  mul_spu_ack,
  mul_spu_shf_ack,
  rst_l,
  rclk
  );
input		rclk;
input		rst_l;			
input		ecl_mul_req_vld; 	
input		spu_mul_req_vld;	
input		spu_mul_acc;		
input 		spu_mul_areg_shf;	
input 		spu_mul_areg_rst;	
input		spu_mul_mulres_lshft;	
output		c0_act;			
output		spick;
output		byp_sel;		
output		byp_imm;
output		acc_imm;
output		acc_actc2, acc_actc3;	
output		acc_actc5;		
output		acc_reg_enb;		
output		acc_reg_rst;		
output		acc_reg_shf;		
output		x2;
output		mul_ecl_ack;		
output		mul_spu_ack;		
output		mul_spu_shf_ack;	
reg 		mul_ecl_ack_d;
reg		mul_spu_ack_d;
reg		c1_act;			
reg		c2_act;			
reg		c3_act;			
reg		favor_e;		
reg 		acc_actc1, acc_actc2, acc_actc3, acc_actc4, acc_actc5;
reg		acc_reg_shf, acc_reg_rst; 
wire		exu_req_vld, spu_req_vld;
wire		epick;			
wire		nobyps;			
wire		noshft;			
wire		acc_reg_shf_in;
wire 		spu_mul_byp = ~spu_mul_acc ; 
wire		clk;
assign clk = rclk ;
assign	c0_act = epick | spick ;				
assign  nobyps = c1_act | acc_actc2 | acc_actc3 | acc_actc4 ; 	
assign  x2 = spick & spu_mul_mulres_lshft;
assign	exu_req_vld = ecl_mul_req_vld & ~c1_act ;
assign	spu_req_vld = spu_mul_req_vld & ~c1_act & ~(nobyps & spu_mul_byp); 
assign	epick = exu_req_vld & ( favor_e | ~spu_req_vld) ; 
assign  spick = spu_req_vld & (~favor_e | ~exu_req_vld) ;
assign    mul_spu_ack = rst_l & spick ;
assign    mul_ecl_ack = rst_l & epick ;
always @(posedge clk)
  begin
	mul_ecl_ack_d <= rst_l & epick ;
	mul_spu_ack_d <= rst_l & spick ;
	c1_act <= rst_l & c0_act ;
	c2_act <= rst_l & c1_act ; 
	c3_act <= rst_l & c2_act ; 
	favor_e <= rst_l & (mul_spu_ack_d & ~mul_ecl_ack_d);		
  end
assign 	byp_sel = spick & spu_mul_byp ;	
assign  noshft = acc_actc1 | acc_actc2 | c3_act | acc_actc4 ;
assign  acc_reg_shf_in =   spu_mul_areg_shf &	
			  ~noshft	    &	
			  ~acc_reg_shf ;	
always @(posedge clk)
  begin
	acc_reg_shf <= rst_l & acc_reg_shf_in ;		
	acc_reg_rst <=  spu_mul_areg_rst ;		
        acc_actc1 <= rst_l & (spick & spu_mul_acc) ;	
        acc_actc2 <= rst_l & acc_actc1 ;			
        acc_actc3 <= rst_l & acc_actc2 ;			
        acc_actc4 <= rst_l & acc_actc3 ;			
        acc_actc5 <= rst_l & acc_actc4 ;			
  end
assign  mul_spu_shf_ack = acc_reg_shf;
assign 	byp_imm = acc_actc5 ;
assign 	acc_imm = (acc_actc2 & acc_actc4) | ((acc_actc2 | acc_actc3) & acc_actc5)  ; 
assign 	acc_reg_enb = acc_actc5 | acc_reg_shf;		
endmodule