module top_module(
	input clk,
	input rst_n,
	input in_valid,
	input[3*3*14-1:0] ar,
	input[3*3*14-1:0] ai,
	input[3*3*14-1:0] br,
	input[3*3*14-1:0] bi,
	output reg[3*3*14-1:0] Cr,
	output reg[3*3*14-1:0] Ci
);integer row,col,cnt;
	reg[3*3*14-1:0] Ar,Ai,Br,Bi;
	always@(posedge clk,negedge rst_n)
		if(!rst_n)begin
			cnt<=0;
			{Cr,Ci}<=0;
			{Ar,Ai,Br,Bi}<=0;
		end else if(in_valid)begin
			cnt<=0;
			{Cr,Ci}<=0;
			{Ar,Ai,Br,Bi}<={ar,ai,br,bi};
		end else if(cnt<3) begin
			cnt<=cnt+1;
			for(row=0;row<3;row=row+1)
			for(col=0;col<3;col=col+1)begin
				Cr[(row*3+col)*14+:14]<=Cr[(row*3+col)*14+:14]+(
					Ar[(row*3+cnt)*14+:14]*Br[(cnt*3+col)*14+:14]
					-Ai[(row*3+cnt)*14+:14]*Bi[(cnt*3+col)*14+:14]
				);
				Ci[(row*3+col)*14+:14]<=Ci[(row*3+col)*14+:14]+(
					Ar[(row*3+cnt)*14+:14]*Bi[(cnt*3+col)*14+:14]
					+Ai[(row*3+cnt)*14+:14]*Br[(cnt*3+col)*14+:14]
				);
			end 
		end else cnt<=cnt;endmodule