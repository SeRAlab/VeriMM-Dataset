module equivalence_resolver(
	clk,rst,datavalid, 
	A,B,C,D,p,hp,np,tp,dp,fp,fn,dd, 
	h_we,t_we,n_we,d_we, 
	h_waddr,t_waddr,n_waddr,d_waddr, 
	h_wdata,t_wdata,n_wdata,d_wdata, 
	HCN,DAC,DMG,CLR,EOC,O 
);
parameter address_bit=9;
parameter data_bit=38;
input clk,rst,datavalid,A,B,C,D,fp,fn;
input [address_bit-1:0]p,hp,np,tp;
input [data_bit-1:0]dp,dd;
output reg h_we,t_we,n_we,d_we;
output reg[address_bit-1:0]h_waddr,t_waddr,n_waddr,d_waddr;
output reg[address_bit-1:0]h_wdata,t_wdata,n_wdata;
output reg[data_bit-1:0]d_wdata;
output HCN,DAC,DMG,CLR,O;
output reg EOC;
reg [address_bit-1:0]cc,h;
reg f,HBF;
wire Ec,Ep;
assign DMG=O&~(f&hp==h);
assign DAC=D;
assign Ec=(C&~D);
assign Ep=(A&~B);
assign O=(B&D&(~A|~C));
assign CLR=Ec;
assign HCN=HBF&(np==p);
always@(posedge clk or posedge rst)
	if(rst)begin
		cc<=0;h<=0;f<=0;
	end
	else if(datavalid)
		if(Ec)begin
			cc<=cc+1; 
			f<=0;	
		end
		else if(O)begin
			h<=h_wdata;f<=1; 
		end
always@*begin
	h_we=0;h_waddr={address_bit{1'bx}};h_wdata={address_bit{1'bx}};
	t_we=0;t_waddr={address_bit{1'bx}};t_wdata={address_bit{1'bx}};
	n_we=0;n_waddr={address_bit{1'bx}};n_wdata={address_bit{1'bx}};
	d_we=0;d_waddr={address_bit{1'bx}};d_wdata={data_bit{1'bx}};
	EOC=0;HBF=0;
	if(Ec)begin
		n_we=1;n_waddr=cc;n_wdata=cc; 
		h_we=1;h_waddr=cc;h_wdata=cc; 
		case(f)
		0:begin d_we=1;d_waddr=cc;d_wdata=dd;end	
		1:begin d_we=1;d_waddr=h;d_wdata=dd;end	
		endcase
	end
	else if(Ep)begin
		case(fp)
		0:begin	d_we=1;d_waddr=np;d_wdata=dp; 
			if(fn)EOC=1;	end	  
		1:begin	h_we=1;h_waddr=np;h_wdata=hp;HBF=1;end	
		endcase
	end
	else if(O)
		case({f,fp})
		2'b00:begin
			h_we=1;h_waddr=np;h_wdata=cc;	
			t_we=1;t_waddr=h_wdata;t_wdata=cc;
		end
		2'b01:begin
			h_we=1;h_waddr=np;h_wdata=hp;	
			t_we=1;t_waddr=h_wdata;t_wdata=cc;
			n_we=1;n_waddr=tp;n_wdata=cc;	
		end
		2'b10:begin
			h_we=1;h_waddr=np;h_wdata=h;	
			t_we=1;t_waddr=h_wdata;t_wdata=cc;
		end
		2'b11:begin
			h_we=1;h_waddr=np;h_wdata=hp;	
			t_we=1;t_waddr=h_wdata;t_wdata=cc;
			n_we=1;n_waddr=tp;n_wdata=h;	
		end
		endcase
end
endmodule