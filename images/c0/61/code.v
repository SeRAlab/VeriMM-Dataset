module table_reader(
	clk,rst,datavalid, 
	A,B,r1,r2,d,O,HCN, 
	d_we,d_waddr,h_rdata,t_rdata,n_rdata,d_rdata,h_wdata,t_wdata, 
	h_raddr,t_raddr,n_raddr,d_raddr, 
	p,hp,np,tp,dp,fp,fn 
);
parameter address_bit=9;
parameter data_bit=38;
input clk,rst,datavalid,A,B,r1,r2,O,HCN,d_we;
input [address_bit-1:0]d_waddr,h_rdata,t_rdata,n_rdata,h_wdata,t_wdata;
input [data_bit-1:0]d,d_rdata;
output [address_bit-1:0]n_raddr,h_raddr,t_raddr,d_raddr;
output reg [address_bit-1:0]p,hp,np;
output [address_bit-1:0]tp;
output [data_bit-1:0]dp;
output reg fp,fn;
reg [address_bit-1:0]Rtp;
reg [data_bit-1:0]Rdp;
reg [address_bit-1:0]pc;
always@(posedge clk or posedge rst)
	if(rst)begin
		pc<=0;p<=0;
	end
	else if(datavalid)begin
		p<=pc;
		if(r1&~r2)begin
			pc<=pc+1;
		end	
	end
assign n_raddr=pc;
assign h_raddr=pc;
assign t_raddr=(HCN)?h_wdata:h_rdata; 
assign d_raddr=(HCN)?h_wdata:h_rdata;
wire DCN;
assign DCN=(d_we)&(d_waddr==hp);
assign tp=(~A&B)?t_rdata:Rtp;
assign dp=(~A&B)?d_rdata:Rdp;
always@(posedge clk or posedge rst)
	if(rst)begin
		np<=0;hp<=0;fp<=0;fn<=0;Rtp<=0;Rdp<=0;
	end
	else if(datavalid)begin
		Rtp<=tp;Rdp<=dp;
		if(DCN)
			Rdp<=d;
		if(~B&r1)begin
			hp<=t_raddr;
			fp<=~(t_raddr==p);
			np<=n_rdata;
			fn<=(n_rdata==p);
		end
		else if(O)begin
			Rtp<=t_wdata;
			fp<=1;
			hp<=h_wdata;
		end
	end
endmodule