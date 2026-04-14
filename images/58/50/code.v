module top_module(pon_en, pon_load, pon_in, pon_out);input pon_en;        
  input pon_load;        
  input [7:0] pon_in;         
  output reg [7:0] pon_out = 8'b10101011;        
    
  always @(posedge pon_load) #1 begin 
	  pon_out <= pon_in; 
  end
  
endmodule