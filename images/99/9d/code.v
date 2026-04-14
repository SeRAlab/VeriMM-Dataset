module top_module(
  input clk,
  input rst,
  input mode_sel,
  input [127:0] key,
  input [7:0] data_in,
  output reg [7:0] data_out // Changed to reg type
);reg [7:0] encrypted_data;
  reg [7:0] decrypted_data;
  reg [127:0] round_key [0:10];
  reg [127:0] state;
  reg [3:0] round;
  
  // Encryption and decryption algorithms
  // ...
  
  always @(posedge clk) begin
    if (rst) begin
      round <= 0;
      state <= 0;
      encrypted_data <= 0;
      decrypted_data <= 0;
      data_out <= 0; // Initialize data_out on reset
    end else begin
      if (mode_sel) begin // Encryption mode
        // Encryption algorithm
        // ...
        data_out <= encrypted_data;
      end else begin // Decryption mode
        // Decryption algorithm
        // ...
        data_out <= decrypted_data;
      end
    end
  end
  
endmodule