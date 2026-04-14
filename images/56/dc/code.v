module top_module(
    input wire clk, reset,
    input wire d_inc, d_dec, d_clr,
    
    
    
    output wire [3:0] dig0, dig1
   );reg [3:0] dig0_reg, dig1_reg, dig0_next, dig1_next;
   

   

   
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            dig1_reg <= 0;
            dig0_reg <= 0;
         end
      else
         begin
            dig1_reg <= dig1_next;
            dig0_reg <= dig0_next;
         end

   
   always @*
   begin
      dig0_next = dig0_reg;
      dig1_next = dig1_reg;
      if (d_clr)
         begin
            dig0_next = 0;
            dig1_next = 0;
         end
      else if (d_inc)
         if (dig0_reg==9)
            begin
               dig0_next = 0;
               if (dig1_reg==9)
                  dig1_next = 0;
               else
                  dig1_next = dig1_reg + 1;
             end
         else  
            dig0_next = dig0_reg + 1;
      else if (d_dec)
         if((dig1_reg == 0) && (dig0_reg < 2))
            begin
               dig0_next = 0;
               dig1_next = 1;
            end
         else if((dig1_reg > 0) && (dig0_reg == 1))
            begin
               dig1_next = dig1_reg - 1;
               dig0_next = 9;
            end
         else if((dig1_reg > 0) && (dig0_reg == 0))
            begin
               dig1_next = dig1_reg - 1;
               dig0_next = 8;
            end   
         else
            dig0_next = dig0_reg - 2;      

   end
   
   assign dig0 = dig0_reg;
   assign dig1 = dig1_reg;

endmodule