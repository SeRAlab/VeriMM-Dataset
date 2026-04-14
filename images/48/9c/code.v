module top_module(
  input [3:0] bin,
  output reg [3:0] bcd // Change output to reg type
);// Define a lookup table for decimal to BCD conversion
  reg [3:0] dec_to_bcd [0:9]; // Change to an array to hold BCD values

  // Initialize BCD values in an initial block
  initial begin
    dec_to_bcd[0] = 4'b0000; 
    dec_to_bcd[1] = 4'b0001; 
    dec_to_bcd[2] = 4'b0010; 
    dec_to_bcd[3] = 4'b0011; 
    dec_to_bcd[4] = 4'b0100; 
    dec_to_bcd[5] = 4'b0101; 
    dec_to_bcd[6] = 4'b0110; 
    dec_to_bcd[7] = 4'b0111; 
    dec_to_bcd[8] = 4'b1000; 
    dec_to_bcd[9] = 4'b1001; 
  end

  // Convert binary to decimal and then to BCD
  always @(*) begin
    // Use bin directly as it is already in binary from 0 to 9
    bcd = dec_to_bcd[bin]; 
  end

endmodule