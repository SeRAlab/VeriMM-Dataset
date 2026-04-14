module top_module(w,y,en);input [2:0] w;
input en;
output [7:0] y; 
reg [7:0] y;


reg k;


always @ (w or en)
begin
	if(en==0)
		y=0;
	else
		begin
			for(k=7;k>-1;k=k-1)
				begin
					y[k]=0;
					if(k==w)
					y[k]=1;
				end
		end
end

endmodule