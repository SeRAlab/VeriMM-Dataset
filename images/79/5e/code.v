module top_module(a,b,cin,sum,cout);input [7:0] a,b;
	input cin;
	output [7:0] sum;
	output cout;
	wire [7:0] p,g,c;
	genvar j;
	for(j=0;j<=7;j=j+1)
	begin
	  assign p[j]=(a[j]^b[j]); 
	  assign g[j]=(a[j]&b[j]); 
	  if (j==0)
	  	assign c[0]=cin;
	  else
	  	assign c[j]=g[j-1]|(p[j-1]&c[j-1]); 
	  
	  assign sum[j]=p[j]^c[j]; 
		end	
		assign cout=c[7];endmodule