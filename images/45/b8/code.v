module top_module(
	clk_in,clk0,clk1,clk2,clk3,
	rst,rst0,rst1,rst2,rst3,
  sel_o,sell,
  pa,pb,pc,p0,p1,p2,p00,p01,p02,ps,pd,ph,
  ddd,ddd0,df_0,df,
);input clk_in,rst,pa,pb,pc,ddd,ddd0;
 input [1:0] sell;
 output clk0,clk1,clk2,clk3;
 output rst0,rst1,rst2,rst3;
 output p0,p1,p2,p00,p01,p02,ps,pd,ph;
 output df,df_0;
 output [1:0] sel_o;
 
 wire clk_in,rst,pa,pb,pc,ddd,ddd0;
reg clk0,clk1,clk2,clk3;
reg rst0,rst1,rst2,rst3;
reg p0,p1,p2,p00,p01,p02,ps,pd,ph;
 reg df,df_0;

 always@(sell)
 begin
			case (sell)
			0: 
				begin
					clk0=clk_in;
					rst0=rst;
					p0=pa;
					p1=pb;
					p2=pc;
					clk1=0;
					rst1=1;
					p00=1;
					p01=1;
					p02=1;
					clk2=0;
					rst2=0;
					ps=1;
					pd=1;
					ph=1;
					df=0;
					df_0=0;
					clk3=0;
					rst3=0;
				end
		  1:
				begin
					clk1=clk_in;
					rst1=rst;
					p00=pa;
					p01=pb;
					p02=pc;
					clk0=clk_in;
					rst0=1;
					p0=1;
					p1=1;
					p2=1;
					clk2=0;
					rst2=0;
					ps=1;
					pd=1;
					ph=1;
					df=0;
					df_0=0;
					clk3=0;
					rst3=0;
				end
		  2 : 
				begin
					clk2=clk_in;
					rst2=rst;
					ps=pa;
					pd=pb;
					ph=pc;
					df=ddd;
					df_0=ddd0;
					clk0=0;
					rst0=0;
					p00=1;
					p01=1;
					p02=1;
					clk1=0;
					rst1=0;
					p0=1;
					p1=1;
					p2=1;
					clk3=0;
					rst3=0;
				end
		  3 :
				begin
					clk3=clk_in;
					rst3=rst;
					clk0=0;
					rst0=0;
					p00=1;
					p01=1;
					p02=1;
					clk1=0;
					rst1=0;
					p0=1;
					p1=1;
					p2=1;
					clk2=0;
					rst2=0;
					ps=1;
					pd=1;
					ph=1;
					df=0;
					df_0=0;
				end
	  endcase
 end
 assign sel_o = sell;
endmodule