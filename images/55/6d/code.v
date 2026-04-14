module top_module(
   input [4:0] num,
   output reg [7:0] out
);always @(num[4:0])
begin
   case (num)
      5'b00000: out = ~8'b00111111; 
      5'b00001: out = ~8'b00000110; 
      5'b00010: out = ~8'b01011011; 
      5'b00011: out = ~8'b01001111; 
      5'b00100: out = ~8'b01100110; 
      5'b00101: out = ~8'b01101101; 
      5'b00110: out = ~8'b01111101; 
      5'b00111: out = ~8'b00000111; 
      5'b01000: out = ~8'b01111111; 
      5'b01001: out = ~8'b01100111; 
      5'b01010: out = ~8'b01110111; 
      5'b01011: out = ~8'b01111100; 
      5'b01100: out = ~8'b00111001; 
      5'b01101: out = ~8'b01011110; 
      5'b01110: out = ~8'b01111001; 
      5'b01111: out = ~8'b01110001; 
      5'b11111: out = ~8'b00000000; 
      default: out = ~8'b00000000; 
   endcase
end

endmodule