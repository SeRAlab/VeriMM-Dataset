module top_module(AA, DOUT);input [6:0] AA; 
  output reg [31:0] DOUT; 
  reg [7:0] dec_bit; 
  wire [4:0] code; 
  wire high,low; 
  assign code = AA[4:0] - {4'd0,&AA[6:5]}; 
  assign high = (AA[6:5] == 2'd0); 
  assign low = AA[6]; 
  always @(code or high or low) 
  case (code[2:0]) 
  3'b000 : dec_bit = {{7{high}},1'b1 }; 
  3'b001 : dec_bit = {{6{high}},1'b1, low }; 
  3'b010 : dec_bit = {{5{high}},1'b1,{2{low}}}; 
  3'b011 : dec_bit = {{4{high}},1'b1,{3{low}}}; 
  3'b100 : dec_bit = {{3{high}},1'b1,{4{low}}}; 
  3'b101 : dec_bit = {{2{high}},1'b1,{5{low}}}; 
  3'b110 : dec_bit = { high ,1'b1,{6{low}}}; 
  3'b111 : dec_bit = { 1'b1,{7{low}}}; 
  endcase 
  always @(code or high or low or dec_bit) 
  case (code[4:3]) 
  2'b00 : DOUT = {{24{high}},dec_bit }; 
  2'b01 : DOUT = {{16{high}},dec_bit,{ 8{low}}}; 
  2'b10 : DOUT = {{ 8{high}},dec_bit,{16{low}}}; 
  2'b11 : DOUT = { dec_bit,{24{low}}}; 
  endcase 
 endmodule