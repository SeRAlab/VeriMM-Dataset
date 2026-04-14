module top_module(	clk, 
			valid, ch_en, srs, full_empty, req, crdy,
			en_out, en_out_l
			);input		clk;
input		valid;
input		ch_en;		
input		srs;		
input		full_empty;	
input		req;		
input		crdy;		
output		en_out;		
output		en_out_l;	






reg	en_out_l, en_out_l2;
reg	full_empty_r;






always @(posedge clk)
	if(!valid)	full_empty_r <= #1 full_empty;

always @(posedge clk)
	if(valid & ch_en & !full_empty_r & crdy & (!srs | (srs & req) ) )
		en_out_l <= #1 1'b1;
	else
	if(!valid & !(ch_en & !full_empty_r & crdy & (!srs | (srs & req) )) )
		en_out_l <= #1 1'b0;

always @(posedge clk)
	en_out_l2 <= #1 en_out_l & valid;

assign en_out = en_out_l & !en_out_l2 & valid;

endmodule