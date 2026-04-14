module top_module(pass,vote,sel);parameter n=9;
output  pass;
input[n-1:0]  vote;
input sel;
integer  sum;
integer  i;
integer b=n*2/3;
integer s=n/3;
reg  pass;
always @(vote)
  begin
	sum=0;
	for(i=0;i<=n-1;i=i+1)	  	
	if(vote[i]) sum=sum+1;
	if(sel&&sum>b)  pass=1;
	else if(!sel&&sum>s) pass=1;
	else  pass=0;
   end
endmodule