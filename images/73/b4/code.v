module top_module(i_data,o_a,o_b,o_c,o_d,o_e,o_f,o_g);input [3:0] i_data; 
  output o_a; 
  output o_b; 
  output o_c; 
  output o_d; 
  output o_e; 
  output o_f; 
  output o_g; 
  wire [6:0] w_out; 
  function [6:0] Decode; 
  input [3:0] data; 
  begin 
  case (i_data) 
  4'h0: Decode = 7'b0000001; 
  4'h1: Decode = 7'b1001111; 
  4'h2: Decode = 7'b0010010; 
  4'h3: Decode = 7'b0000110; 
  4'h4: Decode = 7'b1001100; 
  4'h5: Decode = 7'b0100100; 
  4'h6: Decode = 7'b0100000; 
  4'h7: Decode = 7'b0001111; 
  4'h8: Decode = 7'b0000000; 
  4'h9: Decode = 7'b0000100; 
  4'ha: Decode = 7'b0001000; 
  4'hb: Decode = 7'b1100000; 
  4'hc: Decode = 7'b0110001; 
  4'hd: Decode = 7'b1000010; 
  4'he: Decode = 7'b0110000; 
  4'hf: Decode = 7'b0111000; 
  endcase 
  end 
  endfunction 
  assign w_out = Decode(i_data); 
  assign o_a = w_out[6]; 
  assign o_b = w_out[5]; 
  assign o_c = w_out[4]; 
  assign o_d = w_out[3]; 
  assign o_e = w_out[2]; 
  assign o_f = w_out[1]; 
  assign o_g = w_out[0]; 
 endmodule