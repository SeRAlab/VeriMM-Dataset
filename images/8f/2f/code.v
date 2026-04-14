module top_module( unidades1, decenas1, unidades2, decenas2, count1, count2, clk2);input count1; 
input count2; 
input clk2;
output reg [3:0] unidades2=0;
output reg [3:0] decenas2=0;
output reg [3:0] unidades1=0;
output reg [3:0] decenas1=0;



always @(posedge clk2) begin
   
	if ((count1==1)&&(unidades1<9)) unidades1=unidades1+1;
	
		else if ((count1==1)&&(decenas1==9)&&(unidades1==9)) begin
	decenas1 = 9;
	unidades1= 9;
		end
	else if((count1==1)&&(unidades1==9)) begin  
	
		decenas1=decenas1+1; 
		unidades1=0; 
	end
	
	if ((count2==1)&&(unidades2<9)) unidades2=unidades2+1;
	
		else if ((count2==1)&&(decenas2==9)&&(unidades2==9)) begin
	decenas2 = 9;
	unidades2= 9;
		end
	else if((count2==1)&&(unidades2==9)) begin  
	
		decenas2=decenas2+1; 
		unidades2=0; 
	end
	end
	
   

endmodule