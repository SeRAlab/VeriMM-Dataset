module top_module(
  
  linear_enc_sign, sign,
  
  conv_sig
  );input [11:0] linear_enc_sign;
  input sign; 
  output [11:0] conv_sig;
  
  
  reg [11:0] temp_conv_sig;
  
  always @ (*) begin
	 temp_conv_sig = conv_sig;
    
	 if(sign == 1) begin
	   
		
	   if(linear_enc_sign == -12'b100000000000) begin
			temp_conv_sig = 12'b011111111111;
      end
		else begin
      temp_conv_sig = (~linear_enc_sign) + 1;
		end
    
    end
    else begin
       temp_conv_sig = linear_enc_sign;
     end
   end
	
	assign conv_sig = temp_conv_sig;
	
endmodule