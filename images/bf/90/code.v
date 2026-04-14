module top_module(
   input    		[2:0]    i_data_in,             
   input             		i_data_in_en,          
   output reg  	[7:0]    decoder_out            

 );always@*
   begin
       if (i_data_in_en)
         begin
            case(i_data_in)
               3'd0 :  decoder_out = 8'd7 ;
               3'd1 :  decoder_out = 8'd6 ;
               3'd2 :  decoder_out = 8'd5 ;
               3'd3 :  decoder_out = 8'd4 ;
               3'd4 :  decoder_out = 8'd3 ;
               3'd5 :  decoder_out = 8'd2 ;
               3'd6 :  decoder_out = 8'd1 ;
               3'd7 :  decoder_out = 8'd0 ;
            endcase;
         end
   end

endmodule