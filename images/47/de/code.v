module top_module(

        clk,     
		   addr,    
        wr_n,    
       
        i_data,  
        o_pwm    
       );input  clk,wr_n,addr;
    output  o_pwm;
    input  [19:0]  i_data;
	 
    reg [19:0] period,duty,counter;
	 wire	 o_pwm;

   always@(posedge clk)
       begin
          if(!wr_n) 
             begin
               if(!addr)  
                begin  
                  period<=i_data;
                  duty<=duty;
                end
               else       
                begin
                  period<=period;
                  duty<=i_data;
                end
             end
          else
             begin
                  period<=period;
                  duty<=duty;
             end
      end

  always@(posedge clk)
       begin
         if(!counter)   

            counter<=period;
         else           
            counter<=counter-1;
       end

  assign o_pwm=((counter<duty)?0:1); 

endmodule