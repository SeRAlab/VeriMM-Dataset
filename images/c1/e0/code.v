module wb_dma_pri_enc_sub(valid, pri_in, pri_out);
parameter [3:0]	ch_conf = 4'b0000;
parameter [1:0]	pri_sel = 2'd0;
input		valid;
input	[2:0]	pri_in;
output	[7:0]	pri_out;
wire	[7:0]	pri_out;
reg	[7:0]	pri_out_d;
reg	[7:0]	pri_out_d0;
reg	[7:0]	pri_out_d1;
reg	[7:0]	pri_out_d2;
assign pri_out = ch_conf[0] ? pri_out_d : 8'h0;
always @(pri_sel or pri_out_d0 or pri_out_d1 or  pri_out_d2)
	case(pri_sel)		
	   2'd0: pri_out_d = pri_out_d0;
	   2'd1: pri_out_d = pri_out_d1;
	   2'd2: pri_out_d = pri_out_d2;
	endcase
always @(valid or pri_in)
	if(!valid)		pri_out_d2 = 8'b0000_0001;
	else
	if(pri_in==3'h0)	pri_out_d2 = 8'b0000_0001;
	else
	if(pri_in==3'h1)	pri_out_d2 = 8'b0000_0010;
	else
	if(pri_in==3'h2)	pri_out_d2 = 8'b0000_0100;
	else
	if(pri_in==3'h3)	pri_out_d2 = 8'b0000_1000;
	else
	if(pri_in==3'h4)	pri_out_d2 = 8'b0001_0000;
	else
	if(pri_in==3'h5)	pri_out_d2 = 8'b0010_0000;
	else
	if(pri_in==3'h6)	pri_out_d2 = 8'b0100_0000;
	else			pri_out_d2 = 8'b1000_0000;
always @(valid or pri_in)
	if(!valid)		pri_out_d1 = 8'b0000_0001;
	else
	if(pri_in==3'h0)	pri_out_d1 = 8'b0000_0001;
	else
	if(pri_in==3'h1)	pri_out_d1 = 8'b0000_0010;
	else
	if(pri_in==3'h2)	pri_out_d1 = 8'b0000_0100;
	else			pri_out_d1 = 8'b0000_1000;
always @(valid or pri_in)
	if(!valid)		pri_out_d0 = 8'b0000_0001;
	else
	if(pri_in==3'h0)	pri_out_d0 = 8'b0000_0001;
	else			pri_out_d0 = 8'b0000_0010;
endmodule