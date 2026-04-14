module top_module( key_code, clk, slow_rate );input[4:0]	key_code;
   input 	clk;
   output [12:0] slow_rate;
   reg [12:0] 	 slow;
	
	always @ (posedge clk)
     case (key_code)
       0: slow <= 0;							
       1: slow <= 'D1909;						
       2: slow <= 'D1746;						
       3: slow <= 'D1515;						
       4: slow <= 'D1433;						
       5: slow <= 'D1276;						
       6: slow <= 'D1137;						
       7: slow <= 'D1012;						
       8: slow <= 'D966;						
       9: slow <= 'D852;						
       10: slow <= 'D759;						
       11: slow <= 'D717;						
       12: slow <= 'D638;						
       13: slow <= 'D568;						
       14: slow <= 'D506;						
       15: slow <= 'D478;						
       16: slow <= 'D426;						
       17: slow <= 'D379;						
       18: slow <= 'D358;						
       19: slow <= 'D319;						
       20: slow <= 'D284;						
       21: slow <= 'D253;						
     endcase

   assign slow_rate = slow;

endmodule