module top_module(
  input  [2:0] c_i,      
  output [6:0] disp_o);assign disp_o = (c_i == 3'd0) ? 7'b1000000 :
                  (c_i == 3'd1) ? 7'b1111001 :
                  (c_i == 3'd2) ? 7'b0100100 :
                  (c_i == 3'd3) ? 7'b0110000 :
                  (c_i == 3'd4) ? 7'b0011001 :
                  (c_i == 3'd5) ? 7'b0010010 :
                  (c_i == 3'd6) ? 7'b0000011 :
                   7'b1111000;   
		
endmodule