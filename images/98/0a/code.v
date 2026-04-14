module top_module(
  
  
  
  input [33:0] HADDR,
  
  
  
  output HSELx0,
  output HSELx7,
  output HSELx1,
  output HSELx2,
  output HSELx3,
  output HSELx4,
  output HSELx5,
  output HSELx6
);assign HSELx0=(HADDR[33:17]==17'h000);		
	assign HSELx7=(HADDR[33:17]==17'h001);     	
	assign HSELx1=(HADDR[33:17]==17'h7fe);		
	assign HSELx2=(HADDR[33:17]==17'h7ff);		
	assign HSELx3=(HADDR[33:28]==6'h01);		
	assign HSELx4=(HADDR[33:28]==6'h07);		
	assign HSELx5=(HADDR[33:31]!=3'h0);			
	assign HSELx6={HSELx0,HSELx1,HSELx2,HSELx3,HSELx4,HSELx5,HSELx7}==0;
endmodule