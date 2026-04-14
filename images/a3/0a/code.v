module top_module(  
                               
    
    
	    input Clk,   

    
		output reg SDIN,							   
        output reg SCLK,                    
		output reg LRCK,
		output  MCLK
		);reg [31:0]counter=0;
reg [15:0]count=0;
reg pwm;


integer pwmcount=99;


parameter freq = 100000000/60000;






 
assign MCLK = Clk;
always @(posedge Clk)
 begin
   if (count==0)                                           
	  begin
	   pwm <= (pwmcount==19)? counter[28] : counter[24];  
		pwmcount <= (pwmcount==0)? 99:pwmcount-1;
	
    
	    if (pwm) begin                                              
	      count <= freq/68;
    
	
         LRCK <= 1'b0;
       end			
		 else begin
		   count <= freq/70;
			LRCK <= 1'b1;
			SCLK <= ~SCLK;
		 end
		 
    
		 SDIN <= ~SDIN;                                             
     end
	else 
	   count <= count-1;
	  counter <= counter+1;
  end
endmodule