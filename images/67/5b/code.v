module top_module(X, SSD);input [3:0] X; 
  output reg [6:0] SSD; // Adjusted width from [0:6] to [6:0]
  
  always @* begin // Changed to always @* for combinatorial logic
    case(X) 
      4'b0000: SSD = 7'b0000001; 
      4'b0001: SSD = 7'b1001111; 
      4'b0010: SSD = 7'b0010010; 
      4'b0011: SSD = 7'b0000110; 
      4'b0100: SSD = 7'b1001100; 
      4'b0101: SSD = 7'b0100100; 
      4'b0110: SSD = 7'b0100000; 
      4'b0111: SSD = 7'b0001111; 
      4'b1000: SSD = 7'b0000000; 
      4'b1001: SSD = 7'b0001100; 
      default: SSD = 7'b1111111; // Added default case for safety
    endcase 
  end 
endmodule