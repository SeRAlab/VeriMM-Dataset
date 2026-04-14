module top_module(input wire [1:0] in1,input wire [1:0] in2,output reg [2:0] res);always @* begin 
  case ({in1,in2}) 
  4'b0000 : begin 
  res = 3'b000; 
  end 
  4'b0001 : begin 
  res = 3'b000; 
  end 
  4'b0010 : begin 
  res = 3'b000; 
  end 
  4'b0011 : begin 
  res = 3'b000; 
  end 
  4'b0100 : begin 
  res = 3'b000; 
  end 
  4'b0101 : begin 
  res = 3'b001; 
  end 
  4'b0110 : begin 
  res = 3'b010; 
  end 
  4'b0111 : begin 
  res = 3'b011; 
  end 
  4'b1000 : begin 
  res = 3'b000; 
  end 
  4'b1001 : begin 
  res = 3'b010; 
  end 
  4'b1010 : begin 
  res = 3'b100; 
  end 
  4'b1011 : begin 
  res = 3'b110; 
  end 
  4'b1100 : begin 
  res = 3'b000; 
  end 
  4'b1101 : begin 
  res = 3'b110; 
  end 
  4'b1110 : begin 
  res = 3'b011; 
  end 
  4'b1111 : begin 
  res = 3'b111; 
  end 
  endcase 
  end 
 endmodule