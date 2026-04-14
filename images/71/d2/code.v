module top_module(product,multiplicand,multiplier,clock,start,busy);output reg [7:0] product; 
  output reg busy; 
  input [3:0] multiplicand, multiplier; 
  input wire clock, start; 
  reg [8:0] A, S, P; 
  reg [2:0] index; 
  reg temp; 
  always @(posedge clock or posedge start) begin 
  if (start) begin 
  P = {4'b0000, multiplier, 1'b0}; 
  index = 3'b000; 
  busy = 1'b1; 
  product = 8'b11111111; 
  A = {multiplicand, 5'b00000}; 
  S = {~multiplicand + 1'b1, 5'b00000}; 
  end else if (index < 3'b100) begin 
  case ({P[1], P[0]}) 
  2'b01: P = (P + A); 
  2'b10: P = (P + S); 
  endcase 
  temp = P[8]; 
  P = P >> 1; 
  P[8] = temp; 
  index = index + 1'b1; 
  end else begin 
  busy = 1'b0; 
  {product, temp} = P; 
  index = 3'b111; 
  end 
  end 
 endmodule