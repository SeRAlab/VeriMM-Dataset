module top_module(BIN, SSD);input [3:0] BIN;  // Changed from [15:0] to [3:0] to match the case's range
  output reg [6:0] SSD; // Changed from reg [0:6] to reg [6:0]

  always @(*) begin // Added @(*) sensitivity list for combinational logic
    case(BIN) 
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
      4'b1010: SSD = 7'b0001000; 
      4'b1011: SSD = 7'b1100000; 
      4'b1100: SSD = 7'b0110001; 
      4'b1101: SSD = 7'b1000010; 
      4'b1110: SSD = 7'b0110000; 
      4'b1111: SSD = 7'b0111000; 
      default: SSD = 7'b1111111; // Default case to handle invalid inputs
    endcase 
  end 
endmodule