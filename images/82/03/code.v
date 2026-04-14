module top_module(
		change,turn,count1,count2,counta,countb,LD_min,LD_hour,mode
		);input change,mode,turn; 

output count1,count2,counta,countb,LD_min,LD_hour;

reg[1:0] m = 0;
 
reg fm=0,count1=0,count2=0,counta=0,countb=0,LD_min=1,LD_hour=1;

wire mode,turn,change; 

always@(posedge mode)  
begin if(m > 2)
			m <= 0;
			else m <= m+1;
end 

always@(posedge turn)
begin fm <= ~fm;
end 

always@(m or fm or change)
	begin case(m) 
	2:begin
		if(fm) 
		begin count1<=change;
				{LD_min,LD_hour} <= 1;
		end
		else begin counta<=change;
					  {LD_min,LD_hour}<=2;
				end
				{count2,countb}<=0;
				end 
	1:begin 
		if(fm) 
		begin count2<=change; 
				{LD_min,LD_hour}<=1;
		end 
			else begin countb <= change;
						  {LD_min,LD_hour}<=2;
						  end
						  {count1,counta}<=0;
						  end 
	0:begin{count1,count2,counta,countb,LD_min,LD_hour}<=0;
	
	end
	endcase 
	end
endmodule