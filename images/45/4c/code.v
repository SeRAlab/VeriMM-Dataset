module top_module(a,b);input [7:0] a;
output reg [3:0] b;

reg [7:0] a1;

always@(a or b)
	begin
		a1=a;		
	if(a[7]==1)
		b=a1[7:4];
	else if(a[6]==1)
		b=a1[6:3];
	else if(a[5]==1)
		b=a1[5:2];
	else if(a[4]==1)
		b=a1[4:1];
	else if(a[3]==1)
		b=a1[3:0];
		
	else if(a[2]==1)
		begin
			b[2:0]=a1[2:0];
			b[3]=0;
		end
	else if(a[1]==1)
		begin
			b[1:0]=a1[1:0];
			b[2]=0;
			b[3]=0;
		end
	else if(a[0]==1)
		begin
			b[0]=a1[0];
			b[3:1]=3'b0;
		end
	else
		begin
			b=0;
		end
	end
endmodule