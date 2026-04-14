module top_module(
    input [3:0] num,
    output reg [6:0] dispcode
    );always @( num ) begin
          case (num)
              4'b0000: dispcode = 7'b0000001; 
              4'b0001: dispcode = 7'b1001111; 
              4'b0010: dispcode = 7'b0010010; 
              4'b0011: dispcode = 7'b0000110; 
              4'b0100: dispcode = 7'b1001100; 
              4'b0101: dispcode = 7'b0100100; 
              4'b0110: dispcode = 7'b0100000; 
              4'b0111: dispcode = 7'b0001111; 
              4'b1000: dispcode = 7'b0000000; 
              4'b1001: dispcode = 7'b0000100; 
              4'b1010: dispcode = 7'b0001000;  
              4'b1011: dispcode = 7'b1100000;  
              4'b1100: dispcode = 7'b0110001;  
              4'b1101: dispcode = 7'b1000010;  
              4'b1110: dispcode = 7'b0110000;  
              4'b1111: dispcode = 7'b0111000; 
              default: dispcode = 7'b0000000;  
         endcase
       end
endmodule