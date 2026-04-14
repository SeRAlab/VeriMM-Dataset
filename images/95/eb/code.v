module top_module(light1,light2,light3,LED);input wire light1,light2,light3;
  output reg [3:0]LED;
  
  always @(light1 or light2 or light3)
  begin
    if(light3==1)      
	 begin
		LED<=4'b0111;   
    end	
	 else
	   if(light2==1) LED<=4'b0011;  
		else 
		  if(light1==1)  LED<=4'b0001;  
		  else  LED<=4'b0000;    
  end
  
endmodule